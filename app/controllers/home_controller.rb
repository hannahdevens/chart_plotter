class HomeController < ApplicationController
def index
  @selected_chart_types = [] # Initialize the selected_chart_types variable
  #respond_to do |format|
    #format.html# Render index.html.erb
  #end
end

  def upload
    uploaded_file = params[:csv_file]
    @file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)

    File.open(@file_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end

    redirect_to root_path, notice: 'File uploaded successfully.'
    session[:file_path] = @file_path.to_s
  end

  def generate_chart
    puts "Received params: #{params.inspect}"

    @file_path = session[:file_path]
    line_path = Rails.root.join('lib', 'scripts', 'lineplot.py')
    bar_path = Rails.root.join('lib', 'scripts', 'barplot.py')
    scatter_path = Rails.root.join('lib', 'scripts', 'scatterplot.py')
    @selected_chart_types = params[:chart_types] || []

    # Generate the desired charts based on the selected chart types
    if @selected_chart_types.include?('bar_plot')
      system("python #{bar_path} '#{@file_path}'")
      @bar_plot = '/uploads/barplot.png'
    end
    if @selected_chart_types.include?('scatter_plot')
      system("python #{scatter_path} '#{@file_path}'")
      @scatter_plot = '/uploads/scatterplot.png'
    end
    if @selected_chart_types.include?('line_plot')
      system("python #{line_path} '#{@file_path}'")
      @line_plot = '/uploads/lineplot.png'

  respond_to do |format|
    format.html do
      if @selected_chart_types.any?
        render partial: 'plots', locals: { line_plot: @line_plot, bar_plot: @bar_plot, scatter_plot: 
@scatter_plot }
      else
        render plain: 'No chart types selected.'
      end
    end
  end
end   
end
end
