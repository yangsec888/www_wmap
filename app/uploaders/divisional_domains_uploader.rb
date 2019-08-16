class DivisionalDomainsUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    store_root = Rails.root.join('uploads')
    Dir.mkdir(store_root, 0750) unless Dir.exist?(store_root)
    model_name = model.name
    dir = Rails.root.join('uploads',model_name)
    #Dir.mkdir(dir, 0775) unless Dir.exist?(dir)
    #return dir
  end

  # Domain Portfolio uploader white list
  def extension_white_list
    %w(xlsx)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if model.name == 'upload'
      case model.file_type
      when 'DK'
        'DomainPortfolio-DK.xlsx'
      when 'PPG'
        'DomainPortfolio-PPG.xlsx'
      when 'PYR'
        'DomainPortfolio-PYR.xlsx'
      when 'RHCB'
        'DomainPortfolio-RHCB.xlsx'
      when 'RHPG'
        'DomainPortfolio-RHPG.xlsx'
      when 'UK'
        'DomainPortfolio-UK.xlsx'
      else
        'Error: invalid file_type'
      end
    end
  end

end
