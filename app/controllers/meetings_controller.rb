class MeetingsController < ApplicationController
	include SessionsHelper

	def index
		@meetings = current_user.meetings.where('start_time > (?)', Time.now - 7.hours)
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
		Appointment.where(meeting_id: params[:id], user_id: current_user.id).first.update_attributes accepted: true
		redirect_to conversations_path(meetings: true)
	end

	def show
		@meeting = Meeting.find(params[:id])
		render layout: false
	end

	def check
  	if current_user
  		appointments = current_user.appointments.where( accepted: true, dismissed: nil ).map(&:meeting_id)
      p appointments
      if appointments
        meetings = Meeting.where('id in (?)', appointments).where('start_time < (?)', Time.now - 7.hours ).select {|meeting| meeting.accepted? }
        p meetings
        if !meetings.empty? 
          appointment_ids = meetings.select {|meeting| meeting.start_time < Time.now - 15.minutes - 7.hours }.map(&:appointments)
      	  p appointment_ids
          if appointment_ids
            appointment_ids = appointment_ids.flatten.map(&:id) 
            Appointment.where('id in (?)', appointment_ids).update_all dismissed: true
            p meetings.select {|n| n.start_time > Time.now - 15.minutes - 7.hours }.sort_by {|n| n.start_time}.reverse.first
            puts "\n%" * 50
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
  	meeting.appointments.where(user_id: current_user.id).update_all dismissed: true, rater: true
  	redirect_to meeting.url
  end

end