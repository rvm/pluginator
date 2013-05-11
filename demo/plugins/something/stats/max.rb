class Something::Stats::Max

  def self.handles?(what)
    %w{ max maximum }.include?(what)
  end

  def self.action
    42
  end
end
