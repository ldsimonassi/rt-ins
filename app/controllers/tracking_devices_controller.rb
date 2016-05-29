class TrackingDevicesController < ApplicationController
  before_action :set_tracking_device, only: [:show, :edit, :update, :destroy]

  # GET /tracking_devices
  # GET /tracking_devices.json
  def index
    @tracking_devices = TrackingDevice.all
  end

  # GET /tracking_devices/1
  # GET /tracking_devices/1.json
  def show
  end

  # GET /tracking_devices/new
  def new
    @tracking_device = TrackingDevice.new
  end

  # GET /tracking_devices/1/edit
  def edit
  end

  # POST /tracking_devices
  # POST /tracking_devices.json
  def create
    @tracking_device = TrackingDevice.new(tracking_device_params)

    respond_to do |format|
      if @tracking_device.save
        format.html { redirect_to @tracking_device, notice: 'Tracking device was successfully created.' }
        format.json { render :show, status: :created, location: @tracking_device }
      else
        format.html { render :new }
        format.json { render json: @tracking_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracking_devices/1
  # PATCH/PUT /tracking_devices/1.json
  def update
    respond_to do |format|
      if @tracking_device.update(tracking_device_params)
        format.html { redirect_to @tracking_device, notice: 'Tracking device was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracking_device }
      else
        format.html { render :edit }
        format.json { render json: @tracking_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracking_devices/1
  # DELETE /tracking_devices/1.json
  def destroy
    @tracking_device.destroy
    respond_to do |format|
      format.html { redirect_to tracking_devices_url, notice: 'Tracking device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracking_device
      @tracking_device = TrackingDevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracking_device_params
      params.require(:tracking_device).permit(:serial_no, :device_model_id)
    end
end
