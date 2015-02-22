class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  def index
    @songs = Song.all.order(:title)
  end

  def show
  end

  def new
    @song = Song.new
  end

  def edit
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song, notice: 'Song was successfully created.'
    else
      render :new
    end
  end

  def update
    if @song.update(song_params)
      redirect_to @song, notice: 'Song was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @song.destroy
    redirect_to songs_url, notice: 'Song was successfully deleted.'
  end

  private

    def set_song
      @song = Song.find(params[:id])
    end

    def song_params
      params.require(:song).permit(:song, :title, :artist, :source, :youtube_link)
    end
end
