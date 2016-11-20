class CreateAlLinks < ActiveRecord::Migration
  def change
    create_table :al_links do |t|
      t.string :expression
      t.string :url_template
    end
  end
end
