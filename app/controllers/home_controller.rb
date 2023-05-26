class HomeController < ApplicationController
  def index
    @file_path = params[:file_path]
    @selected_chart_types = params[:chart_types] || []
  end

  def upload
    uploaded_file = params[:csv_file]
    @file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)

    File.open(@file_path, 'wb') do |file|
      file.write(uploaded_file.read)

      redirect_to root_path, notice: 'File uploaded successfully.'
  session[:file_path] = @file_path.to_s

  end

    # Define the file paths for Python scripts
    @selected_chart_types = params[:selected_chart_types] || []

#    bar_path = Rails.root.join('lib', 'scripts', 'barplot.py')
#    scatter_path = Rails.root.join('lib', 'scripts', 'scatterplot.py')
     line_path = Rails.root.join('lib', 'scripts', 'lineplot.py')

#   system("python #{line_path} #{file_path}")

 def generate_chart
  @file_path = session[:file_path]
  @bar_path = session[:bar_path]
  @scatter_path = session[:scatter_path]
  line_path = Rails.root.join('lib', 'scripts', 'lineplot.py')
  @line_path = line_path
  bar_path = Rails.root.join('lib', 'scripts', 'barplot.py')
  @bar_path = bar_path
  scatter_path = Rails.root.join('lib', 'scripts', 'scatterplot.py')
  @scatter_path = scatter_path
  @selected_chart_types = params[:'chart_types'] || []
  puts "Received chart types: #{params[:chart_types]}"
  puts "File_path: '#{@file_path}'"    
    # Generate the desired charts based on the selected chart types
    if @selected_chart_types.include?('bar_plot')
      system("python #{@bar_path} '#{@file_path}'")   
    end
    if @selected_chart_types.include?('scatter_plot')
     system("python #{@scatter_path} '#{@file_path}'")
    end
    if @selected_chart_types.include?('line_plot')
     system("python #{line_path} '#{@file_path}'")
#  @line_plot = '/uploads/lineplot.png'

  render 'generate_chart'
end
end
end
end
#end
