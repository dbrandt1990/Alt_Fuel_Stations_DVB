class NotesController < ApplicationController
    def create
        @station= Station.find(params[:note][:station_id])
        Note.create(content: params[:content], user_id: current_user.id, station_id: params[:note][:station_id], admin: admin?)
        redirect_to station_path(@station)
    end

    def destroy
        note = Note.find(params[:id])
        station = Station.find(note.station_id)
        note.destroy
        redirect_to station_path(station)
    end

end