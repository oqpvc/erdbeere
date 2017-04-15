# coding: utf-8
class ExamplesController < ApplicationController
  def show
    @example = Example.find(params[:id])
  end

  def find
    @satisfies = params[:satisfies].to_a.map { |i| Atom.find(i.to_i) }.to_a
    @violates = params[:violates].to_a.map { |i| Atom.find(i.to_i) }.to_a

    if (@satisfies + @violates).empty? then
      flash[:error] = 'You didn\'t look for anything.'
      redirect_to main_search_path
    end

    @all_that_is_satisfied = @satisfies.all_that_follows.to_a
    unless (@all_that_is_satisfied & @violates).empty?
      flash.now[:error] = "Such an object cannot exist"
      render 'violates_logic'
    end

    p params[:structure_id]

    @almost_hits = Example.where('structure_id = ?', params[:structure_id].to_i).all.to_a.find_all do |e|
      (@satisfies - e.all_that_is_satisfied).empty? && (@violates & e.all_that_is_satisfied).empty?
    end
    
    if @almost_hits.empty? then
      flash.now[:warning] = "I don't know of any such object ☹"
    else
      @hits = @almost_hits.find_all do |e|
        (@violates - e.all_that_is_violated).empty?
      end
    end
    p flash
  end
end
