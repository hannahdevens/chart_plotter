class HomeController < ApplicationController
skip_before_action :verify_authenticity_token

  def index
    @selected_chart_types = [] # Initialize the selected_chart_types variable
    @charts_data = {}
  end

  def upload
    data_files = Array(params[:data_files])
    data_files.each do |file|
      uploaded_file = file
      if File.extname(uploaded_file.original_filename) == '.asc'
        file_path = Rails.root.join('public', 'uploads', 'userexpt', 'data', uploaded_file.original_filename)

        File.open(file_path, 'wb') do |f|
          f.write(uploaded_file.read)
        end

        puts "Data ASC file upload done"
        session[:data_file_paths] ||= [] # Initialize session[:data_file_paths] as an empty array if it doesn't exist
        session[:data_file_paths] << file_path.to_s # Add the file path to the session array
      else
        # Handle invalid data file format (not .asc)
        puts "Invalid data file format"
        # You can add error handling logic or redirect the user to an error page
      end
    end

    mapping_files = Array(params[:mapping_files])
    mapping_files.each do |file|
      uploaded_file = file
      file_extension = File.extname(uploaded_file.original_filename)
      if file_extension == '.csv' || file_extension == '.txt'
        file_path = Rails.root.join('public', 'uploads', 'userexpt', 'mapping', uploaded_file.original_filename)

        File.open(file_path, 'wb') do |f|
          f.write(uploaded_file.read)
        end

        puts "Mapping #{file_extension} file upload done"
        session[:mapping_file_paths] ||= [] # Initialize session[:mapping_file_paths] as an empty array if it doesn't exist
        session[:mapping_file_paths] << file_path.to_s # Add the file path to the session array
      else
        # Handle invalid mapping file format (not .csv or .txt)
        puts "Invalid mapping file format"
        # You can add error handling logic or redirect the user to an error page
      end
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
      system("python3 lib/scripts/amigagitsimplified/amiga.py summarize -i public/uploads/userexpt/")
    @line_plot_pdf_paths = Dir.glob(Rails.root.join('public', 'uploads', 'userexpt', 'figures', '*.pdf'))
    end

    if @selected_chart_types.include?('scatter_plot')
      system("python #{scatter_path} '#{@file_path}'")
      @scatter_plot = '/uploads/scatterplot.png'
    end

    if @selected_chart_types.include?('bar_plot')
      system("python #{bar_path} '#{@file_path}'")
      @bar_plot = '/uploads/barplot.png'
    end

    respond_to do |format|
      format.html do
        if @selected_chart_types.any?
          render partial: 'plots', locals: { bar_plot: @bar_plot, 
line_plot_pdf_paths: @line_plot_pdf_paths, scatter_plot: @scatter_plot }
        else
          render plain: 'No chart types selected.'
        end
      end
    end
  end
end

