module Transformer

   #Adds a method called "transform_#{format}(files_to_transform, sub_folder_to_start_at, output_folder"
   #
   #Where:
   # _files\_to\_transform_: is an array of absolute paths of files to transform
   #
   # _sub\_folder\_to\_start\_at_: is the path from which the output folder should begin creating sub_folders
   #
   # _output\_folder_: is the location where you expect resulting/transformed files to end up.
   #
   def add_transformer_for(input_format, output_format, &block)

     define_method("transform_#{input_format}") do |files_to_transform, output_folder, sub_folder_to_start_at, *options| 

       messages = []
       files_to_transform.each do |file|
         if File.extname(file) == ".#{input_format}"
           output_folder = output_folder + File.dirname(file).gsub(Regexp.escape(sub_folder_to_start_at), '') if sub_folder_to_start_at
           output_folder.gsub!(/\/$/, '')
           FileUtils.makedirs(output_folder) unless File.directory?(output_folder)
           output_path = "#{output_folder}/#{File.basename(file, '.'+input_format)}.#{output_format}"
           output = File.open(output_path, 'w')
           output.write(yield(file, options))
           output.close
           messages << "Regenerated #{file}"
         end
       end
       messages.join("\n")
     end
  end
end
