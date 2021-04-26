require_relative './api_controller.rb'

class StationsController < ApplicationController
    def show 
        render station_path(params[:id])
    end

    def update

    end

    def destroy

    end
end