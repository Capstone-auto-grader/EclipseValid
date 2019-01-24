module ValidatorHelper
  require 'zip'
  def validate zip_file
    tmp = Tempfile.new
    tmp.binmode
    tmp.write zip_file.read
    tmp.close
    proj_structure = [['pom.xml',false], ['.classpath', false], ['.project', false] ].to_h
    one_root = true
    # puts "ENTERING #{tmp.path}"
    begin
      Zip::File.open(tmp.path) do |zip_file|
        first_file = zip_file.entries.first.name
        root = first_file.slice 0..(first_file.index '/')

        zip_file.each do |entry|
          puts entry.name
          proj_structure.keys.each do |key|
            proj_structure[key] = true if entry.name.include? key.to_s
            one_root = false unless entry.name.start_with? root
          end
        end
      end
    rescue
      return status_string proj_structure.keys.reject { |k| proj_structure[k] }, one_root
    ensure
      tmp.close
      tmp.unlink
    end

    status_string proj_structure.keys.reject { |k| proj_structure[k] }, one_root
  end

  def status_string(missing_files, one_root)
    if missing_files.empty? && one_root
      s = "Congratulations! That's a valid Eclipse export!"
    else
      s = "Sorry, that's not a valid Eclipse export."
      s += '<br>Your export contains more than one root directory.' unless one_root
      s += "<br>You're missing #{missing_files.join(', ')}" unless missing_files.empty?
    end
    s
  end

end
