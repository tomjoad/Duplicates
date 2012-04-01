#class for searching duplicates of files

require 'digest/md5'

class Duplicates

  attr_reader :files, :duplicates

  def initialize(start_dir)
    raise ArgumentError, "#{start_dir} is not correct directory name!" unless File.directory?(start_dir)
    @start_dir = start_dir
    @files = Array.new()
    @md5 = Hash.new()
    @duplicates = Hash.new()
  end

  # list duplicates

  def list_dups(include_subfolders = false)
    @include_subfolders = include_subfolders
    load_files
    calculate_md5
    search_for_duplicates
    if @duplicates == {}
      puts "There are no duplicates!"
    else
      @duplicates.each do |d|
        puts d[1].to_s + " => " + d[0].to_s
      end
    end
    return nil
  end

  # list all files & their md5s

  def list_all(include_subfolders = false)
    @include_subfolders = include_subfolders
    load_files
    calculate_md5
    @files.each do |f|
      puts f + "=" + @md5[f]
    end
    return nil
  end

  private

  # load list of files

  def load_files
    @files =
    Dir.chdir(@start_dir) do
      if @include_subfolders == false
        Dir['*.*']
      else
        Dir['**/*.*']
      end
    end
  end

  # calculate md5 for each file

  def calculate_md5
    @files.each do |f|
      @md5[f] = Digest::MD5.hexdigest(File.read(@start_dir + "/" + f))
    end
  end

  # search for duplicates

  def search_for_duplicates
    d_md5 = Hash[@md5.sort - @md5.invert.invert.sort].invert.keys.sort
    @duplicates = @md5.dup
    @duplicates.delete_if {|k,v| not(d_md5.include?(v))}
    @duplicates = Hash[@duplicates.sort_by {|k,v| v}]
  end

end
