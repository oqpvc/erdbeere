# coding: utf-8

class ExamplesController < ApplicationController
  def show
    @example = Example.find(params[:id])
  end

  def find
    @satisfies = params[:satisfies].to_a.map { |i| Atom.find(i.to_i) }.to_a
    @violates = params[:violates].to_a.map { |i| Atom.find(i.to_i) }.to_a

    if (@satisfies + @violates).empty?
      flash[:error] = I18n.t('examples.find.flash.no_search_params')
      redirect_to main_search_path
    end

    @satisfied_atoms_with_implications = @satisfies.all_that_follows_with_implications
    @satisfied_atoms = @satisfied_atoms_with_implications.first
    unless (@satisfied_atoms & @violates).empty?
      flash.now[:error] = I18n.t('examples.find.flash.violates_logic')
      render 'violates_logic'
    end

    @almost_hits = Example.where('structure_id = ?', params[:structure_id].to_i).all.to_a.find_all do |e|
      (@satisfies - e.satisfied_atoms).empty? && (@violates & e.satisfied_atoms).empty?
    end

    if @almost_hits.empty?
      flash.now[:warning] = I18n.t('examples.find.flash.nothing_found')
    else
      @hits = @almost_hits.find_all do |e|
        (@violates - e.computable_violations).empty?
      end
    end
  end
end
