# frozen_string_literal: true

class GoogleSpreadsheetsController < ApplicationController
  before_action :google_auth

  def index
    @state = params[:state]
    @speakers = @speakers_worksheet.rows
  end

  def new
    @argument = GoogleSpreadsheet.new
  end

  def create
    if @bought_tickets_worksheet.rows.flatten.include?(google_params['email'])
      if @registered_users_worksheet.rows.map { |row| row[2] }.exclude?(google_params['email'])
        row = [google_params[:speaker], google_params[:timeslot], google_params[:email], google_params[:name],
               google_params[:phone], google_params[:note]]
        @registered_users_worksheet.insert_rows(@registered_users_worksheet.num_rows + 1, [row])
        @registered_users_worksheet.save

        redirect_to action: 'index', state: 'successfully_registered'
      else
        redirect_to action: 'index', state: 'already_registered'
      end
    else
      redirect_to action: 'index', state: 'need_registration'
    end
  end

  def google_auth
    session = GoogleDrive::Session.from_service_account_key('client_secret.json')

    spreadsheet = session.spreadsheet_by_title('DKINC')

    @registered_users_worksheet = spreadsheet.worksheet_by_title('Registered users')
    @bought_tickets_worksheet = spreadsheet.worksheet_by_title('Bought tickets')
    @speakers_worksheet = spreadsheet.worksheet_by_title('Speakers')
  end

  private

  def google_params
    params.permit(:speaker, :timeslot, :email, :name, :phone, :note)
  end
end
