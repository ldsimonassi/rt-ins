class DriverReportController < ApplicationController
  include DriverReportHelper
  include TimeHelper
  include SessionsHelper

  def index
  end

  def show
	  if not logged_in?
      redirect_to login_path
    end
    @period = params[:period]

    if !@period || !['LAST24H', 'YESTERDAY', 'LAST7D', 'LAST30D'].include?(@period)
      @period = 'YESTERDAY'
    end
    
    curr = get_current_fiction_time

    @labels = Array.new

    case @period
      when 'LAST24H'
        @to = get_current_fiction_time
        @from = get_past_fiction_time((24*60*60)-1)
        hour = @from

        24.times do
          @labels << hour.strftime('%H:%M')
          hour = hour + (60*60)
        end
      when 'YESTERDAY'
        @from = Time.new(curr.year, curr.month, curr.mday, 0, 0, 0) - (24*60*60) # Yesterday 00:00:00hs
        @to = @from + ((24*60*60) - 1) # Yesterday 23:59:59hs
        hour = @from
        24.times do
          @labels << hour.strftime('%H:%M')
          hour = hour + (60*60)
        end

      when 'LAST7D'
        @to = Time.new(curr.year, curr.month, curr.mday, 0, 0, 0) - 1
        @from = @to - ((24*60*60*7) -1)
        hour = @from
        7.times do
          @labels << hour.strftime('%d/%m')
          hour = hour + (60*60*24)
        end

      when 'LAST30D'
        @to = Time.new(curr.year, curr.month, curr.mday, 0, 0, 0) - 1
        @from = @to - ((24*60*60*30) -1)
        hour = @from
        30.times do
          @labels << hour.strftime('%d/%m')
          hour = hour + (60*60*24)
        end

    end

    @from_s = @from.strftime("%d/%m/%Y %H:%M:%S")
    @to_s = @to.strftime("%d/%m/%Y %H:%M:%S")

  	@driver = current_user.drivers.find(params[:id])
  	@tracks = @driver.device_tracks

  end
end
