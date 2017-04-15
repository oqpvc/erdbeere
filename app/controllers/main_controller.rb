class MainController < ApplicationController
  def overview
  end
  def search
    if params[:satisfies].nil? && params[:violates].nil?
      render 'search'
    else
      satisfies = params[:satisfies].map{ |i| Atom(i.to_i) }
      p satisfies
      render 'search'
    end
  end
end
