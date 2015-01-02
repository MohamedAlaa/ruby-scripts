require 'benchmark'
require 'fileutils'
require 'fastimage'
require 'json'

# Images Project
# ===================

# Validation
# => * Check if the photo is square
# => * Bigger than 350px width o height

time = Benchmark.realtime do

  # Define Some Variables
  directory = Dir["source/*"]
  minimum_size = 350
  images = []
  valid = []
  invalid = []

  valid_dir = 'valid/'
  invalid_dir = 'invalid/'

  # Clear Folders Before Start
  FileUtils.rm_rf(Dir.glob([
    invalid_dir + '*',
      valid_dir + '*'
  ]))

  # Copy Images Valid/Invalid to the appropriate folder
  def copy_to_folder(src, dst)
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)
  end

  # Return true if Image is square
  def is_square(width, height)
    if width == height
      return true
    end

    return false
  end

  # Return true if image match minimum size requirement
  def match_minimum_size(width, height, min)
    if ( width && height ) < min
      return false
    end

    return true
  end

  # Write JSON Results
  def write_json(file, results)
    File.open(file,'w') do |f|
      f.write(JSON.pretty_generate(results))
    end
  end

  directory.each do |file|
    obj = {
      'image' => file,
      'size' => FastImage.size(file, :raise_on_failure=>true),
      'type' => FastImage.type(file, :raise_on_failure=>true),
      'validation' => {
        # We assume Good Intentions
        'square_image' => true,
        'minmum_size_match' => true
      }
    }

    ## Validate If Image is Square
    obj['validation']['square_image'] = is_square(obj['size'][0], obj['size'][1])
    obj['validation']['minmum_size_match'] = match_minimum_size(obj['size'][0], obj['size'][1], minimum_size)

    if (obj['validation']['square_image'] == false) || (obj['validation']['minmum_size_match'] == false)
      # Invalid Image
      invalid.push( obj )
      copy_to_folder( obj['image'], invalid_dir)
    else
      # Valid Image
      valid.push( obj )
      copy_to_folder( obj['image'], valid_dir)
    end

    images.push(obj)
    obj = {}
  end

  # Print results in json files
  write_json('results.json', images)
  write_json('valid/valid.json', valid)
  write_json('invalid/invalid.json', invalid)

end

# Benchmark End
puts "Time elapsed #{time*1000} milliseconds"