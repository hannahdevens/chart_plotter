class HomeController < ApplicationController
def index
  @selected_chart_types = [] # Initialize the selected_chart_types variable
  @charts_data = {}
  #respond_to do |format|
    #format.html# Render index.html.erb
  #end
end

def upload
  params[:csv_files].each do |file|
    uploaded_file = file
    file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)

    File.open(file_path, 'wb') do |f|
      f.write(uploaded_file.read)
    end

    puts "File upload done"
    session[:file_paths] ||= [] # Initialize session[:file_paths] as an  empty array if it doesn't exist
    session[:file_paths] << file_path.to_s # Add the file path to the session array
  end

  redirect_to root_path, notice: 'Files uploaded successfully.'
end

  def generate_charts
    puts "Received params: #{params.inspect}"

    @file_path = session[:file_path]
    line_path = Rails.root.join('lib', 'scripts', 'lineplot.py')
    bar_path = Rails.root.join('lib', 'scripts', 'barplot.py')
    scatter_path = Rails.root.join('lib', 'scripts', 'scatterplot.py')
    @selected_chart_types = params[:chart_types] || []
    # Generate the desired charts based on the selected chart types
    if @selected_chart_types.include?('line_plot')
      system("python #{line_path} '#{@file_path}'")
      @line_plot = '/uploads/lineplot.png'
    
    if @selected_chart_types.include?('scatter_plot')
      system("python #{scatter_path} '#{@file_path}'")
      @scatter_plot = '/uploads/scatterplot.png'
    
    if @selected_chart_types.include?('bar_plot')
      system("python #{bar_path} '#{@file_path}'")
      @bar_plot = '/uploads/barplot.png'
    end
    end
    end
  respond_to do |format|
    format.html do
      if @selected_chart_types.any?
        render partial: 'plots', locals: { bar_plot: @bar_plot, line_plot: @line_plot, scatter_plot: @scatter_plot }
      else
        render plain: 'No chart types selected.'
      end
    end
  end
end   
end
