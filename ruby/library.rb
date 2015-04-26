require 'readline'
require 'pp'

module Day
  #read note can't use yesterday can't add 1
  lines = File.readlines('libraryday.txt')
  lines.each { |line| @yesterday = line.to_i }
  # puts "original object0_____> #{DAY_initialise.object_id}"
  # advance day
  @yesterday +=1
  # puts "original object1_____> #{DAY_initialise.object_id}"
  # "original object_____> #{DAY.object_id}"
  #write back day
  File.write('libraryday.txt', @yesterday) #refresh file to see new rewrite value.
  #read day
  lines = File.readlines('libraryday.txt')
  lines.each { |line| DAY = line.to_i }  #.to_i.freeze
  # puts "original object2_____> #{DAY.object_id}"
  #puts "a new day has been instantiated"
  # puts "Today is day: #{DAY}!".puple
end
#Day.freeze
class Calendar
  include Day
  # puts "_______"
  # @@underline = puts 50.times{ "-".red}
  # day = [1]
  #start
  def initialize(file='libraryday.txt')  # read | used every day
    @file = file
    # puts "initialize file is day #{DAY}  "
    # puts "original object_____ #{DAY.object_id}"
    # puts "call advance"
    advance
  end

  def advance
    # puts "original object_____ #{DAY.object_id}"
    puts "\nToday is day #{DAY}.".bold
  end
  # def resetDate #sets day to 0
  #   puts DAY+"_______________________________"
  #   p    "Resetting day..."
  #   puts "_______________________________"
  #   File.write('libraryday.txt', '0')
  #   lines = File.readlines('libraryday.txt', 'w')
  #   lines.each do |line| DAY = line.to_i
  #   end
  #   p "Reset to today: #{DAY}!"
  # end
end #end of class

#ref Ivan Black,May 3 '13, Colorized Ruby output, http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  # def reverse_color;  "\033[7m#{self}\033[27m" end
end


class Book
  include Day
  book_id = 0
  attr_accessor :id, :title, :author, :due_date
  @@book_class = []
  @@overdue_books = []
  def initialize(id=0, title="", author="", due_date=nil)
    # http://ruby-doc.org/core-2.2.0/NilClass.html#Or—Returns false if obj is nil or false; true otherwise.
    @id       = id
    @title    = title
    @author   = author
    @due_date = due_date
  end

  def to_s
     #"#{@id}: #{@title}, by #{@author}"  #both work
    "#{id}: #{title}, by #{author} & #{due_date}"
  end
  #-------read file section--------------------------------------------------------------------------
  #
  #  writes file to array
  #
  def read_collection
    @@book_class = []
    lines = File.readlines('collection.txt')
    lines.each do| line |
      line_parts = line.split('/')
      @id        = id+1
      title      = line_parts[0].chomp
      author     = line_parts[1].chomp
      @due_date  = due_date = nil.to_i
      @@book_class << Book.new(id, title, author, due_date) #class implementation
    end #do
    # print_all
  end

  #
  # writes file to array
  #
  def read_aperm
    @@book_class = []
    lines = File.readlines('aperm.txt')
    lines.each do| line |
      line_parts = line.split('/')
      @id        = line_parts[0].to_i
      title      = line_parts[1]
      author     = line_parts[2]
      @due_date  = line_parts[3].to_i
      @@book_class << Book.new(id, title, author, due_date) #class implementation
    end #do
    # print_all
  end
  #---------print section------------------------------------------------------------------------
  #
  # print
  # due_date
  #
  # def print_books_array
  #   @@book_class.each do | book |
  #     if book.due_date != nil
  #     puts book.id, book.title
  #     end
  #   end
  # end
  #
  # def print_all
  #   puts @@book_class
  # end

  #---------Books checkout--------------------------------------------------------------

  def get_due_date #returns date book due integer
    loan_days = 7
    takeout_day = nil
    lines = File.readlines('libraryday.txt')
    lines.each{| line | takeout_day = line}
    takeout_day.chomp
    due_date = takeout_day.to_i + loan_days
    return due_date
  end

  # finds book at user entered id, put due_date in this book
  def check_out
    puts '\n'.bg_green
    puts 'CHECKOUT'.red.bold

    puts 'Enter the book id?'.red.bold
    my_book_id = gets.chomp.to_i
    puts "to member loan #{@loan}"
    #loan1 = my_book_id
    # members = Member.new
    # members.get_loan(@book_id_1)

    lines = File.new('aperm.txt', 'r+') #new file/wipe
    @@book_class.each_with_index do | book |
      if my_book_id == book.id
        #inserts due_date for this one book
        book.due_date = get_due_date
        # lines.close
        # writes to screen
        puts "#{book.id}: #{book.title} by #{book.author} due back: #{book.due_date},\n\n"
      end
    end
    #printout whole book array
    # puts @@book_class
  end #end take out

  #---------Books write to file section--------------------------------------------------------------

  # array to file
  def write_array_to_file
    lines = File.new('aperm.txt', 'w+')

  @@book_class.each_with_index do | book |
    lines.puts "#{book.id}/#{book.title}/#{book.author}/#{book.due_date}"end
    lines.close
  end

  def find_all_available_books #from array
    print "\n".bg_cyan
    puts "AVAILABLE BOOKS".bold
    # lines = File.new('aperm.txt', 'r') #new file/wipe
    @@book_class.each do | book |
      if book.due_date < DAY
        puts book
        book
        # puts "#{book.id}/#{book.title}/#{book.author}/#{book.due_date}"end
      end
    end
  end
  # --------section search-----------------------------------------------

  #
  # SEARCH GET_AUTHOR
  #
  def get_author
    puts "Search Author. Enter 4 letters".red
    puts ">".magenta.bold
    r = gets[0..3].chomp
    puts "Searching... #{r}".red
    i = 0
    @@book_class.each do | book |
      book.author.chomp
      x = book.author.chomp
      answer =  /#{r}/i =~ x
      # puts answer
      if answer != nil
        # puts x
        puts "Author: #{x}"
        # pp "id: #{book.book_id}, title #{book.title}".chomp #, date due: #{book.due_date}
      end
    end
    i +1
  end #method

  #
  # SEARCH GET_TITLE
  #
  def get_title
    puts "Search Title. Enter 4 letters".red
    puts ">".magenta.bold
    r = gets[0..3].chomp
    puts "Searching... #{r}".red
    i = 0
    @@book_class.each do | book |
      book.title.chomp
      x = book.title.chomp
      answer =  /#{r}/i =~ x
      # puts answer
      if answer != nil
        # puts x
        puts "Title: #{x}"

      end
    end
    i +1
  end #method

  #
  # SEARCH GET_TITLE AND AUTHOR
  #
  def get_search
    puts "Search Title or Author. Enter 4 or more letters.".blue
    puts ">".blue.bold
    @@found_title_match = []; @@found_author_match = [];
    all_title_array = []; all_author_array=[]

    r = gets[0..20].chomp
    if r.length < 4
      puts "Search string must contain at least four characters".blue
      get_search
    else
      puts "Searching... #{r}".red
      @@book_class.each do | book |
        regx_result = /#{r}/i =~ book.title.chomp
        if regx_result != nil
          @@found_title_match << book
        end
      end

      @@book_class.each do | book |
        regx_result_author = /#{r}/i =~ book.author.chomp
        if regx_result_author != nil
          @@found_author_match << book
        end
      end
    end
    # puts "group by value".cyan
    # ref http://ruby-doc.org/core-2.2.1/Enumerable.html#method-i-group_by
    all_title_array= @@found_title_match.group_by{|book| book.title}
    all_author_array = @@found_author_match.group_by{|book| book.author}

    # puts "first".cyan
    # ref: http://ruby-doc.org/core-2.2.0/Array.html#method-i-first
    all_title_array.merge!(all_author_array)
    all_title_array.each{|k,v|p v.first.to_s.chomp}
    # all_author_array.each{|k,v|p v.first.to_s.chomp} :keep
  end #method

  #
  # SEARCH GET_ID
  #
  def get_id
    i = 0
    puts "Search id enter a number".blue
    puts ">".magenta.bold
    r = gets[0..3].chomp.to_i
    puts "Searching... #{r}".red
    @@book_class.each do | book |
      x = book.book_id.to_i
      if r == x
        # puts "id: #{x}"
        pp "id: #{book.book_id}" #, author #{book.author}".chomp #, date due: #{book.due_date}
      end
      i +1
    end

  end #method

  # --------section search menu-----------------------------------------------
  def book_search
    print "\n".bg_green
    puts "BOOK SEARCH MENU".bold
    puts "Title(1), Author(2), ID(3), Search all(4), back to Main Library Menu(b)"
    puts "Enter a number to Search".blue
    print '>'.blue.bold
    search = gets.chomp

    if search == "Q"
      exit
    else
      case search
        when "1"
          get_title
        when "2"
          get_author
        when "3"
          get_id
        when "4"
          get_search
        when "b"
          lib = Library.new
          lib.lib_menu
        else "enter a number to search"
      end
      book_search
    end
  end



end#books class///////////////////////////////////////////////////////////////

class Member < Book
  include Day
  attr_accessor :member_id, :member_name, :book_id_1, :book_id_2, :book_id_3
  @@member_array = []

  def initialize(member_id=0, member_name="", book_id_1=nil, book_id_2=nil, book_id_3=nil)
    @member_id = member_id
    @member_name = member_name
    @book_id_1 = book_id_1
    @book_id_2 = book_id_2
    @book_id_3 = book_id_3
    #puts "a new MEMBER has been instantiated"
    # puts "values ",@member_name, @book_id_1
    # @@member_array = [] #??
  end

  #
  # 1. append file to array.
  #
  def read_members
    @@member_array = []
    lines = File.readlines('members.txt')
    lines.each do| line |
      line_parts = line.split('/')

      member_id   = line_parts[0].to_i
      member_name = line_parts[1]
      book_id_1   = line_parts[2].to_i
      book_id_2   = line_parts[3].to_i
      book_id_3   = line_parts[4].to_i

      @@member_array << Member.new(member_id, member_name, book_id_1, book_id_2, book_id_3) #class implementation
    end #do
    write_array_to_file
    # pp @@member_array  #test
    puts "\n\n"
  end

  #
  # 1. Get new member name
  # write new member to array
  def check_out #issue_card(name_of_member)
    puts 'What is your first name?'.red
    member_name = gets.chomp
    member_name.capitalize!
    lines = []
    # book_id_1 = 0
    # book_id_2 = 0
    # book_id_3 = 0
    #https://coderwall.com/p/mre_ea/get-the-first-last-or-n-line-of-a-text-file-in-ruby
    lines = File.open("members.txt").to_a

    line_parts = lines.last.split('/') # elements split at "/" to make array
    member_id = line_parts[0].to_i+1 # take first element

    print "Member name: #{member_name}. Member id: #{member_id}".blue.bold
    @@member_array << Member.new(member_id, member_name, book_id_1, book_id_2, book_id_3)
    pp @@member_array  #test
  end

  #
  # 3. write array to file
  #
  def write_array_to_file
    lines = File.new('members.txt', 'w')

    @@member_array.each_with_index do | member |
      lines.puts "#{member.member_id}/#{member.member_name}/#{member.book_id_1}/#{member.book_id_2}/#{member.book_id_3}"
    end
    lines.close
  end



  def checkout_member

    puts 'Enter your Member id?'.red.bold
    my_member_id = gets.chomp.to_i

    puts 'Enter Book id?'.red.bold
    my_book_id = gets.chomp.to_i

    puts "Your member id is: #{my_member_id}"

    @@member_array.each_with_index do | member |
      if my_member_id == member.member_id
        # book_id_1 = my_book_id_1
        puts "serving: #{member.member_name}"
        puts "#{member.member_id}, #{member.member_name}  #{member.book_id_1=my_book_id},\n\n"
      end
    end #end take out
  end

  #need full array
  def send_notice
    booklist = Book.new
    booklist.read_aperm #1
    members = Member.new
    members.read_members
    puts "Send overdue noice.".red.bold
    @@member_array.each do |member|
      if member.book_id_1 > 0
           @@book_class.each do |book|
             if book.id == member.book_id_1
             puts ".".red * 100 + "\n"
             print "Member ID: #{member.member_id}"," #{member.member_name}, ","Book ID: #{book.id}, ","Book title: #{book.title}, ","Due date #{book.due_date}\n".red
             end
          end
      end
    end
    puts "\n"
  end
end #end class



    # borrowers.match @@overdue_books
  # end
  #
  #4. write to array
  #
  # Memberss.new(@@member_id, @@member_name, @@book_id_1, @@book_id_2, @@book_id_3) #class implementation
  # def write_to_array
  #   line = File.open('members.txt', 'r')
  #   line.each_with_index do | x |
  #     @@member_array << x end
  #   line.close
  # end

  #***********************************************
  #5. print array
  #***********************************************
  # def print_array
  #   puts "\nwhat's in the array?***********************\n".red
  #
  #  puts @@member_array.index(48)   #=> 1
  #   # @@member_array .index("z")   #=> nil
  #   puts "\nwhat's in the array?\n***********************".red
  #
  #  @@member_array.each_with_index do |x|
  #  puts x.red
  #  end
  #   puts "\nthat's all?".red
  # end

  #
  #6. pretty print array
  #

  # def pp_array
  #   # puts "\nwhat's in the array?\n".red
  #   # # @@member_array.each_with_index do |x|
  #   # #   @@member_array.each { |i| print i, "\n"
  #   # #   }
  #   # puts "\nthis is @@member_array[13]\n".red
  #   # print @@member_array
  #   #   end
  #   @@member_array[2,4]=[]
  #   @@member_array.each { |i| print i, "\n"}
  #   # end
  #   puts "\nthat's all?".red
  #
  #   lines = File.new('members.txt', 'a+') #makes a new file if it doesn't exist but if so won't do first bit
  #   lines.print "\n",@member_id,", ",@member_name,", ",@book_id_1,", ",@book_id_2,", ",@book_id_3
  #
  #   puts "LIBRARY_CARD".blue
  #   puts "Member:   #{@member_name}".blue
  #   puts "ID Number: #{@member_id}".blue
  #   puts "Book_1     #{@book_id_1}".blue
  #   puts "Book_2     #{@book_id_2}".blue
  #   puts "Book_3     #{@book_id_3}".blue
  #
  #
  #   # @@member_array.each_with_index do |number, index|
  #   #   number.each_with_index do |line, row|
  #   #     # print index, row, line, "\n"
  #   #     print row"\n"
  #   #   end
  #   # end
  # end
  # ********************************************************************
  # PRINTOUT
  # *********************************************************************
  # def printnow
  #   @@member_array.each do | member |
  #
  #     puts " ID: #{@member_id}, Mem: #{@member_name}".blue
  #   end
  # end
  # # *********************************************************************



class Library

  include Day
  loan = 7


  # attr_accessor :book_id_1, :book_id_2, :book_id_3
  #
  # def initialize(book_id_1=nil,book_id_2=nil,book_id_3=nil)
  #   @book_id_1 = book_id_1
  #   @book_id_2 = book_id_2
  #   @book_id_3 = book_id_3
  # end


  lib = Calendar.new


    def lib_menu
      booklist = Book.new
      print "\n".bg_gray
      puts "MAIN LIBRARY MENU".bold
      puts "Check out(1), Check in(2), Search(3), Add member(4), Send overdue notics(5), Quit(q), Initialize(i) wipes borrowing."
      puts "Enter a number to Search".blue
      print ">".blue.bold

      controls = gets.chomp
      if controls == "Q"
        exit
      else
        case controls

          when "i" #start
            initialize_menu
          when "0" #check out
             run_menu
          when "1" #check out
            checkout_menu
          when "2" #check in
            checkin_menu
          when "3" #search
                      booklist = Book.new
                      booklist.read_collection
                      # booklist.read_bks_list#reads in txt books into array
                      # booklist.read_bks_list2
                      # booklist.print_bks_array
                      # booklist.to_s
                      booklist.book_search
          when "4" #add member
                 member_menu
          when "5"
                overdue_menu
          when "q"
            exit
          else "enter a number to search"
        end
        lib_menu
      end
    end


  def initialize_menu #s
    booklist = Book.new
    booklist.read_collection#1.
    booklist.checkout_member
    booklist.write_array_to_file
  end

  def run_menu
    booklist = Book.new
    booklist.read_aperm #1
    # booklist.check_out
    # booklist.get_loan#4.
    booklist.write_array_to_file
  end

  def checkout_menu #1
    booklist = Book.new
    booklist.read_aperm #1
    booklist.check_out
    # booklist.get_loan#4.
    # booklist.write_array_to_file
  end
  #
  # def checkin_menu
  #
  # end

  def member_menu
    members = Member.new
    members.read_members
    members.checkout_member
    members.write_array_to_file
    members.checkout_member
  end

  def overdue_menu #5
    members = Member.new
    booklist = Book.new
    booklist.read_aperm #1
    booklist.find_all_available_books
    members.send_notice
  end

end #lib
lib = Library.new
lib.lib_menu