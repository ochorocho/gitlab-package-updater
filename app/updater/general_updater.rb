class GeneralUpdater

  def initialize(options)
    @options = options
  end

  def updates_available?(object)
    object.any?
  end

  def headline(keys)
    '| ' + keys.join(' | ') + " |\n"
  end

  def headline_seperator(keys)
    headline = '| '
    keys.each do |field|
      separate = "----------------------------------------------------".slice(1..field.length)
      headline += "#{separate} | "
    end
    headline += "\n"
  end
end