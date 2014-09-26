class MeetingsController < ApplicationController
	include SessionsHelper
	skip_before_filter :require_login, :only => :check

	def index
		@meetings = current_user.meetings.where('start_time > (?)', Time.now - 7.hours)
		@past_meetings = current_user.meetings.where(past: true)
		@ratings = current_user.appointments.where(rater: true)
		current_user.update_attributes meeting_count: 0
		render layout: false
	end

	def create
		meeting = Meeting.new(params[:meeting])
		other_user = User.find(params[:meeting][:recipient])
		new_count = other_user.meeting_count + 1
		other_user.update_attributes meeting_count: new_count
		meeting.name = "#{current_user.id}-#{other_user.id}"
		if meeting.save
			current_user.meetings << meeting
			Appointment.where(user_id: current_user.id, meeting_id: meeting.id).first.update_attributes(accepted: true)
			other_user.meetings << meeting
			meeting.create_zoom_meeting
			@current_meeting = meeting
			MeetingNotificationWorker.perform_async other_user.id, current_user.id, meeting.id
			#NotificationMailer.meeting_notification(other_user, current_user, meeting).deliver if other_user.notify_meetings
		end

		render layout: false
	end

	def rate
		@meeting = Meeting.find(params[:id])
		render layout: false
	end

	def destroy
		Meeting.find(params[:id]).destroy
		redirect_to conversations_path(meetings: true)
	end

	def accept
		meeting = Meeting.find params[:id]
		Appointment.where(meeting_id: params[:id], user_id: current_user.id).first.update_attributes accepted: true
		other_user = meeting.other_user(current_user.id)
		if meeting.accepted?
			MeetingConfirmationWorker.perform_async current_user.id, other_user.id, meeting.id
			MeetingReminderWorker.perform_at (meeting.start_time - 15.minutes), current_user.id, other_user.id, meeting.id
			#NotificationMailer.meeting_confirmation(current_user, other_user, meeting).deliver
		end
		redirect_to conversations_path(meetings: true)
	end

	def show
		@meeting = Meeting.find(params[:id])
		@status = @meeting.status current_user
		render layout: false
	end

	def check
  	if current_user
  		appointments = current_user.appointments.where( accepted: true, dismissed: nil ).map(&:meeting_id)
      p appointments
      puts "past appointments"
      if appointments
        meetings = Meeting.where('id in (?)', appointments).where('start_time < (?)', Time.now - 7.hours ).select {|meeting| meeting.accepted? }
        p meetings
        puts "meetings"
        if !meetings.empty? 
          appointment_ids = meetings.select {|meeting| meeting.start_time < Time.now - 15.minutes - 7.hours }.map(&:appointments)
      	  p appointment_ids
      	  puts "app ids"
          if appointment_ids
            appointment_ids = appointment_ids.flatten.map(&:id) 
            Appointment.where('id in (?)', appointment_ids).update_all dismissed: true
            p meetings.select {|n| n.start_time > Time.now - 15.minutes - 7.hours }.sort_by {|n| n.start_time}.reverse.first
            puts "\n% meetings" * 50
            @current_meeting =  meetings.select {|n| n.start_time > Time.now - 15.minutes - 7.hours}.sort_by {|n| n.start_time}.reverse.first
          end
        end
      else
        @current_meeting = nil
      end
    end
    render layout: false
  end

  def join
  	meeting = Meeting.find params[:id]
  	meeting.update_attributes past: true
  	meeting.appointments.where(user_id: current_user.id).update_all dismissed: true, rater: true
  	redirect_to meeting.url
  end

end