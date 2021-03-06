class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @notes = Note.where(user_id: current_user).order("created_at DESC")
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html {redirect_to @note, notice: 'Note was successfully created.'}
        format.js
      else
        render 'new'
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def update
    if @note.update(note_params)
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: 'Note updated.' }
        format.js 
      end
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    # redirect_to notes_path

    respond_to do |format|
      format.html { redirect_to notes_path, notice: 'Note deleted.'}
      format.js
    end
  end

  private

  #show, edit, update and destroy
  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
