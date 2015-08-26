class IndexController < ApplicationController

  DATA_DIR = Rails.root.join('data')

  def index
    @data = Parser.parse(DATA_DIR)
  end
end
