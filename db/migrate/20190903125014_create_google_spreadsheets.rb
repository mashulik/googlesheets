class CreateGoogleSpreadsheets < ActiveRecord::Migration[5.2]
  def change
    create_table :google_spreadsheets do |t|
      t.string :speaker
      t.string :time_slot
      t.string :email
      t.string :name
      t.string :phone
      t.string :note

      t.timestamps
    end
  end
end
