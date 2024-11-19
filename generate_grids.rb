require 'optparse'

class LFDGrid
  attr_accessor :orbitals, :nx, :ny, :nz,
                :lx, :ly, :lz, :dt, :occ,
                :orbitals_out, :nx_out, :ny_out, :nz_out,
                :lx_out, :ly_out, :lz_out

  def initialize
    self.orbitals = 32
    self.nx = 32
    self.ny = 32
    self.nz = 32
    self.lx = 3.96905 * 2
    self.ly = 3.96905 * 2
    self.lz = 3.96905 * 2
    
    self.dt = "6.0e-3"
    self.occ = 16
    
    self.orbitals_out = 0
    self.nx_out = 0
    self.ny_out = 0
    self.nz_out = 0
    self.lx_out = 0
    self.ly_out = 0
    self.lz_out = 0
  end

  def mutate_grid(multiples)
    for i in 1..multiples do
      mutate_grid_x(i)
      mutate_cell_x(i)
      for j in 1..multiples do
        mutate_grid_y(j)
        mutate_cell_y(j)
        for k in 1..multiples do
          mutate_grid_z(k)
          mutate_cell_z(k)
          for n in 1..multiples do        
            mutate_orbitals(n)
            write_file(i,j,k,n)
          end
        end
      end
    end
  end

  def mutate_orbitals(mul)
    self.orbitals_out  = self.orbitals * mul
  end

  def mutate_grid_x(mul)
    self.nx_out = self.nx * mul
  end

  def mutate_grid_y(mul)
    self.ny_out = self.ny * mul
  end

  def mutate_grid_z(mul)
    self.nz_out = self.nz * mul
  end

  def mutate_cell_x(mul)
    self.lx_out = self.lx * mul
  end

  def mutate_cell_y(mul)
    self.ly_out = self.ly * mul
  end

  def mutate_cell_z(mul)
    self.lz_out = self.lz * mul
  end

  def write_file(a,b,c,d)
    filename = "benchmark_system_#{self.nx_out}_#{self.ny_out}_#{self.nz_out}_#{self.orbitals_out}.in"
    File.open(filename, "w") { |f| 
      f.write("#{self.nx_out} #{self.ny_out} #{self.nz_out}\n")
      f.write("#{self.orbitals_out} #{self.occ}\n")
      f.write("#{self.lx_out} #{self.ly_out} #{self.lz_out}\n")
      f.write("#{self.dt}\n")
      f.flush
    }
    puts "wrote to benchmark_system_#{a}_#{b}_#{c}_#{d}.in"
  end

end

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: generate_benchsystem.rb [options] -m <multiples>"
  parser.separator ""
  parser.separator "options"

  parser.on("-m", "--multiple NUM", Integer, "The multiples for nx, ny nz and norb to generate files") do |mul|
    options[:m] = mul
  end

end.parse!

lfd_grid = LFDGrid.new()
lfd_grid.mutate_grid(options[:m])
