class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
	  
	  @event.update_attribute(:user_id, current_user.id)

    respond_to do |format|
      if @event.save
        format.html { redirect_to(main_app.calendar_view_path) }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
	  
	@event.update_attribute(:updated_id, current_user.id)
	  
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
	
	def attend

		@event = Event.find(params[:id])
		if(Rsvp.all.where(:event_id => @event.id, :user_id => current_user.id).count(:all) == 1)
			@rsvp = Rsvp.find_by(event_id: @event.id, user_id: current_user.id)
			@rsvp.update_attribute(:status, true)
			respond_to do |format|
					format.html { redirect_to(main_app.calendar_view_path) }
					format.json { render :show, status: :created, location: @event }
			end
		else
			@attend = Rsvp.new
			@attend.update_attribute(:event_id, @event.id)
			@attend.update_attribute(:user_id, current_user.id)
			@attend.update_attribute(:status, true)
			@attend.save
			respond_to do |format|
					format.html { redirect_to(main_app.calendar_view_path) }
					format.json { render :show, status: :created, location: @event }
			end
		end
	
	end
	
	def absent
		@event = Event.find(params[:id])
		if(Rsvp.all.where(:event_id => @event.id, :user_id => current_user.id).count(:all) == 1)
			@rsvp = Rsvp.find_by(event_id: @event.id, user_id: current_user.id)
			@rsvp.update_attribute(:status, false)
			respond_to do |format|
					format.html { redirect_to(main_app.calendar_view_path) }
					format.json { render :show, status: :created, location: @event }
			end
		else
			@attend = Rsvp.new
			@attend.update_attribute(:event_id, @event.id)
			@attend.update_attribute(:user_id, current_user.id)
			@attend.update_attribute(:status, false)
			@attend.save
			respond_to do |format|
					format.html { redirect_to(main_app.calendar_view_path) }
					format.json { render :show, status: :created, location: @event }
			end
		end
	
	end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
		params.require(:event).permit(:name, :description, :start_time, :end_time, :address, :zip, :latitude, :longitude)
    end
end
