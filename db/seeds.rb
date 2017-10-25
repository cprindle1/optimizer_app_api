# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
require 'httparty'
require 'date'

def getprojections(position)
  if position == 'DST'
    position = 'DEF'
  end
 response = HTTParty.get('https://www.fantasyfootballnerd.com/service/weekly-projections/json/'+ENV['myKey']+'/'+position, format: :plain)
  proj = JSON.parse response, symbolize_names: true
  proj[:Projections].each do |x|
    currPlayer = []
    projection = 0
    value = 0
    projection += x[:passYds].to_f*0.04
    projection += x[:passTD].to_f*4
    projection += x[:passInt].to_f*-1
    projection += x[:rushYds].to_f*0.1
    projection += x[:rushTD].to_f*6
    projection += x[:recYds].to_f*0.1
    projection += x[:recTD].to_f*6
    projection += x[:receptions].to_f*0.1
    projection += x[:fumblesLost].to_f*-1
    projection += x[:defInt].to_f*2
    projection += x[:defFR].to_f*2
    projection += x[:defSack].to_f*1
    projection += x[:defTD].to_f*6
    projection += x[:defRetTD].to_f*6
    projection += x[:defSafety].to_f*2

    if x[:rushYds].to_f >= 100
      projection += 3
    end
    if x[:passYds].to_f >= 300
      projection += 3
    end
    if x[:recYds].to_f >= 100
      projection += 3
    end
    if position == "DEF"
      if x[:defPA].to_f == 0
        projection += 10
      elsif x[:defPA].to_f <= 6
        projection += 7
      elsif x[:defPA].to_f <= 13
        projection += 4
      elsif x[:defPA].to_f <= 20
        projection += 1
      elsif x[:defPA].to_f <= 27
        projection += 0
      elsif x[:defPA].to_f <= 34
        projection += -1
      else
        projection += -4
      end
      currPlayer = Player.where(Name: x[:displayName].split.last.rstrip+" ")
    elsif
      currPlayer = Player.where(Name: x[:displayName])
    end

    if currPlayer[0] != nil
      currPlayer[0][:projection] = projection
      currPlayer[0][:team] = x[:team]
      currPlayer[0][:gameTime] = currPlayer[0][:GameInfo].split(' ', 2).last
      team1 = currPlayer[0][:GameInfo].split(' ', 2).first.split('@', 2).first
      team2 = currPlayer[0][:GameInfo].split(' ', 2).first.split('@', 2).last
      if currPlayer[0][:team] == team1
        currPlayer[0][:opponent] = team2
      elsif currPlayer[0][:team] ==team2
        currPlayer[0][:opponent] = team1
      end
      if projection > 0
        currPlayer[0][:Value] = (currPlayer[0][:Salary].to_f)/projection
      else
        currPlayer[0][:Value] = 9999999
      end
      currPlayer[0].save
    end
  end
end

CSV.foreach('DKSalaries.csv', headers: true) do |row|
  player = row.to_hash
  Player.create(row.to_hash)
end

getprojections('QB')
getprojections('RB')
getprojections('WR')
getprojections('TE')
getprojections('DST')
Player.where(:Value => nil).destroy_all
