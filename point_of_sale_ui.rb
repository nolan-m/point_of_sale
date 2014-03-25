require 'active_record'
require './lib/product'
require './lib/cashier'
require './lib/sale'
require './lib/transaction'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  system('clear')
  choice = nil
  until choice == 'e'
    puts '**************************************'
    puts 'press a to access the admin menu'
    puts 'press c to access the cashier login'
    puts 'press e to exit'
    puts '**************************************'
    choice = gets.chomp
    case choice
    when 'a'
      admin_menu
    when 'c'
      cashier_login
    when 'e'
      puts 'goodbye'
    else
      puts 'try again'
    end
  end
end

def admin_menu
  system('clear')
  puts '**********************************************************'
  puts "Type c to add a cashier"
  puts "Type p to add a product"
  puts "Type lp to list all products and access the products menu"
  puts "Type lc to list all cashiers and access the cashier menu"
  puts "Type return to start the return process."
  puts "Type s to search for sales by date"
  puts "Type main to exit to main menu"
  puts '**********************************************************'
  case gets.chomp
  when 'c'
    add_cashier
  when 'p'
    add_product
  when 's'
    search_by_date
  when 'return'
    return_menu
  when 'lp'
    list_products_admin_ui
  when 'lc'
    list_cashiers_admin_ui
  when 'main'
    main_menu
  else
    puts 'please try again'
  end
end

def cashier_main_menu(cashier)
  system('clear')
  puts '**************************************'
  puts "Welcome #{cashier.name}."
  puts "Type s to start a new sale"
  puts "Type lp to list all the products"
  puts "Type ls to list all sales"
  puts '**************************************'
  case gets.chomp
  when 's'
    new_sale_menu(cashier)
  when 'lp'
    list_products
    puts 'press any key to return to the cashier menu'
    input = gets.chomp
    cashier_main_menu(cashier)
  when 'ls'
    list_sales(cashier)
  when 'm'
    main_menu
  else
    'not a valid choice'
  end
end

def list_sales_admin
  Sale.all.each do |sale|
    puts ("ID = #{sale.id} | #{sale.total}")
  end
end

def list_sales(cashier)
  Sale.where(cashier_id: cashier.id).each do |sale|
    puts ("Sales for #{cashier.name}")
    puts ("ID = #{sale.id} | #{sale.total}")
  end
  puts "Type view ID to see all transactions for the sale."
  input = gets.chomp.split
  case input[0]
  when 'd'
    # delete
  when  'view'
    Transaction.where(sale_id: input[1].to_i).each do |transaction|
      puts "#{Product.find(transaction.product_id).name} x #{transaction.quantity}  Total: #{transaction.total}"
    end
    puts "Press enter to return to cashier menu"
    input = gets.chomp
    cashier_main_menu(cashier)
  end
end

def return_menu
  list_sales_admin
  puts 'What is the sale number for the return?'
  sale_id = gets.chomp.to_i
  return_transaction_from_sale_id = Transaction.where(sale_id: sale_id)
  return_transaction_from_sale_id.each do |transaction|
    puts "Transaction ID: #{transaction.id}. Product:#{Product.find(transaction.product_id).name} x #{transaction.quantity}  Total: #{transaction.total}"
  end

  puts "What is the transaction ID of the item being returned?"
  return_transaction = Transaction.find_by(id: gets.chomp)
  puts "What quantity do you want to return?"
  return_quantity = gets.chomp.to_i
    if return_quantity == return_transaction.quantity
      return_transaction.destroy
    elsif return_quantity < return_transaction.quantity
      return_transaction.quantity = return_transaction.quantity - return_quantity
      return_transaction.total = return_transaction.quantity * Product.find(return_transaction.product_id).price
      return_transaction.save
    else
      puts "Invalid quantity"
      return_menu
    end

  final_total = Transaction.where(sale_id: sale_id).sum('total')
  return_sale = Sale.where(sale_id: sale_id)
  return_sale.total = final_total
  return_sale.save
  puts "Return accepted.  Refund issued for: #{return_quantity * Product.find(return_transaction.product_id).price}"
  admin_menu
end


def new_sale_menu(cashier)
  current_sale = Sale.create({:cashier_id => cashier.id})
  add_product_to_sale(current_sale, cashier)
end

def add_product_to_sale(current_sale, cashier)
  list_products
  puts "Enter product name: "
  product = Product.find_by name: gets.chomp
  puts "Enter quantity:"
  quantity = gets.chomp.to_i

  Transaction.create({:product_id => product.id, :sale_id => current_sale.id, :quantity => quantity, :total => (product.price * quantity)})

  puts 'Do you want to add another sale?  yes or no'
  choice = gets.chomp
  case choice
  when 'yes'
    add_product_to_sale(current_sale, cashier)
  when 'no'
    tab_out(current_sale, cashier)
    cashier_main_menu(cashier)
  else
    puts 'not a valid option'
  end
end

def tab_out(current_sale, cashier)
  puts "Items: "
  Transaction.where(sale_id: current_sale.id).each do |transaction|
    puts "#{Product.find(transaction.product_id).name} x #{transaction.quantity}  Total: #{transaction.total}"
  end
  final_total = Transaction.where(sale_id: current_sale.id).sum('total')
  current_sale.total = final_total
  current_sale.save
  puts "Final Total: #{current_sale.total}"
  puts "Press any key to return to cashier menu"
  input = gets.chomp
  cashier_main_menu(cashier)
end


def add_cashier
  puts "Enter cashier name:"
  name = gets.chomp
  puts "Enter the cashier username:"
  username = gets.chomp
  new_cashier = Cashier.create({:name => name, :username => username})
  puts "#{new_cashier.name} added to database"
  puts "\nPress 'a' to add another cashier or 'e' to exit back to admin menu"
  case gets.chomp
  when 'a'
    add_cashier
  when 'e'
    admin_menu
  else
    "Invalid Choice."
    admin_menu
  end
end

def list_cashiers_admin_ui
  list_cashiers
  puts "Type d to delete a cashier"
  puts "Type m to return to the main menu"
  case gets.chomp
  when 'd'
    puts "What cashier do you want to remove?"
    input = Cashier.find_by(name: gets.chomp)
    input.destroy
  when 'm'
    admin_menu
  else
    puts 'invalid entry'
    list_cashiers_admin_ui
  end
end

def list_products_admin_ui
  list_products
  puts "Type d to delete a product"
  puts "Type m to return to the main menu"
  case gets.chomp
  when 'd'
    puts "What product do you want to remove?"
    input = Product.find_by(name: gets.chomp)
    input.destroy
  when 'm'
    admin_menu
  else
    puts 'invalid entry'
    list_products_admin_ui
  end
end

def list_products
  Product.all.each { |product| puts "#{product.name}  $#{product.price}"}
end

def list_cashiers
  Cashier.all.each { |cashier| puts "Name: #{cashier.name} - Username: #{cashier.username}" }
end

def add_product
  puts "Enter the product name:"
  name = gets.chomp
  puts "Enter the product price:"
  price = gets.chomp
  new_product = Product.create({:name => name, :price => price})
  puts "#{new_product.name} added to database"
  puts"\nPress 'a' to add another product or 'e' to exit to admin menu"
  case gets.chomp
  when 'a'
    add_product
  when 'e'
    admin_menu
  else
    puts 'Invalid choice.'
    admin_menu
  end
end

def cashier_login
  if Cashier.all.empty?
    puts "please add a cashier first"
    main_menu
  else
    puts 'What is your cashier login?'
    current_cashier = Cashier.find_by username: gets.chomp
    cashier_main_menu(current_cashier)
  end
end

def search_by_date
  puts "Enter a search starting date (MM/DD/YYYY):"
  start_date = gets.chomp
  puts "Enter a search end date (MM/DD/YYYY):"
  end_date = gets.chomp
  found = Sale.where(:created_at => start_date..end_date)
  found.each {|sale| puts "ID = #{sale.id}  Cashier: #{Cashier.find(sale.cashier_id).name}  Total: #{sale.total}  On: #{sale.created_at.strftime("%A %B %d %Y")}" }
  puts "Total amount sold : #{found.sum('total')}"
    total = 0
    # total = found.count{ |sale| sale.cashier_id == Cashier.all[1].id }
    total = found.count

    Cashier.all.each do |cashier|
      total = 0
      found.each do |item|
        if item.cashier_id == cashier.id
          total += 1
        end
      end
      puts "#{cashier.name} - Total Sales #{total}"
    end

  puts "press enter to return to the admin menu"
  input = gets.chomp
  admin_menu
end

main_menu
