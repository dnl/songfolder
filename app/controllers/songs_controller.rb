class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  def index
    @songs = Song.all
  end

  def show
    @setlist = Setlist.find(params[:setlist_id]) if params[:setlist_id].present?
    @song.in_key = key_param if key_param.match Song::KEY_RE
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

    def key_param
      params[:key].gsub(/[+ s]/,'#')
    end

    def song_params
      params.require(:song).permit(:song, :title, :artist, :source, :youtube_link)
    end
end
