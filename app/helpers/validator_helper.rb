module ValidatorHelper
  require 'zip'
  def validate zip_file
    tmp = Tempfile.new
    tmp.binmode
    tmp.write zip_file.read

    proj_structure = [['pom.xml',false], ['.classpath', false], ['.project', false] ].to_h
    begin
      Zip::File.open(tmp.path) do |zip_file|	
        zip_file.each do |entry|	
          proj_structure.keys.each do |key|	
            if entry.name.include? key.to_s	
              proj_structure[key] = true	
            end	
          end	
        end	
      end	
    rescue
      return status_string proj_structure.reject { |k,v| v}	
    ensure
      tmp.close
      tmp.unlink
    end

    status_string proj_structure.reject { |k,v| v}	
  end

  def status_string missing_files
    if missing_files.empty?
      "Congratulations! It's a valid Eclipse export!"
    else
      "Sorry, that's not a valid Eclipse export. You are missing #{missing_files.keys.join(', ')}"
    end
  end

end
