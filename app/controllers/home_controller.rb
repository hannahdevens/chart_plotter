class HomeController < ApplicationController
def index
  @selected_chart_types = [] # Initialize the selected_chart_types variable
  respond_to do |format|
    format.html# Render index.html.erb
  end
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
    end

    respond_to do |format|
      format.js { render layout: false } # Render generate_chart.js.erb
      format.turbo_stream { render partial: 'plots', locals: { selected_chart_types: @selected_chart_types 
}}
    end
  end
end

