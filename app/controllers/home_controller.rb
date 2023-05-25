class HomeController < ApplicationController
  def index
    @file_path = params[:file_path]
    @selected_chart_types = params[:chart_types] || []
  end

  def upload
    uploaded_file = params[:csv_file]
    file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)

    File.open(file_path, 'wb') do |file|
      file.write(uploaded_file.read)
  end

    # Define the file paths for Python scripts

#    bar_path = Rails.root.join('lib', 'scripts', 'barplot.py')
#    scatter_path = Rails.root.join('lib', 'scripts', 'scatterplot.py')
     line_path = Rails.root.join('lib', 'scripts', 'lineplot.py')

#   system("python #{line_path} #{file_path}")

 def generate_chart
#    @bar_path = params[:bar_path]
#    @scatter_path = params[:scatter_path]
    @line_path = params[:line_path]
#    @file_path = params[:file_path]
    @selected_chart_types = params[:selected_chart_types] || []
    
    # Generate the desired charts based on the selected chart types
#    if @selected_chart_types.include?('bar_plot')
#      system("python #{@bar_path} #{@file_path}")   
#    end
#    if @selected_chart_types.include?('scatter_plot')
#      system("python #{@scatter_path} #{@file_path}")
#    end
    if @selected_chart_types.include?('line_plot')
      system("python #{line_path} #{file_path}")
    end    
  @plot_path = '/uploads/lineplot.png'
  render 'generate_chart'
end
end
end
#end
#end
