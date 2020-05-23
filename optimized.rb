# frozen_string_literal: true

require 'json'
require 'pry'
require 'date'
require 'set'

module Optimized
  def work(file = 'data/data_100_000.txt')
    data = parse_file(file)
    users = data[:users]
    sessions = data[:sessions]

    report = {}

    uniqueBrowsers = Set.new
    sessions.values.flatten.each {  |s| uniqueBrowsers.add(s['browser']) }

    report[:totalUsers]          = users.count
    report[:uniqueBrowsersCount] = uniqueBrowsers.count
    report[:totalSessions]       = data[:total_sessions]
    report[:allBrowsers]         = uniqueBrowsers.to_a.sort!.join(',')
    report[:usersStats] = {}

    users.each do |u_id, user|
      user_sesssions = sessions[u_id]
      report[:usersStats][user["full_name"]] = user_stat(user_sesssions)
    end

    File.write('result.json', "#{report.to_json}\n")
  end


  def parse_user(fields)
    {
      'id' => fields[1],
      'full_name' => "#{fields[2]} #{fields[3]}",
      'age' => fields[4]
    }
  end

  def parse_session(fields)
    {
      'user_id' => fields[1],
      'browser' => fields[3].upcase!,
      'time' => fields[4].to_i,
      'date' => fields[5].chomp!
    }
  end

  def user_stat(user_sessions)
    sessions_times = user_sessions.map { |s| s['time'] }
    user_browsers = user_sessions.map { |s| s['browser'] }.sort!

    {
      'sessionsCount' => user_sessions.count,
      'totalTime' => sessions_times.sum.to_s + ' min.',
      'longestSession' => sessions_times.max.to_s + ' min.',
      'browsers' => user_browsers.join(', '),
      'usedIE' => user_browsers.any? { |b| b.start_with?("INTERNET EXPLORER") },
      'alwaysUsedChrome' => user_browsers.all? { |b| b.start_with?("CHROME") },
      'dates' => user_sessions.map { |s| s['date'] }.sort! { |a, b| b <=> a }
    }
  end

  def parse_file(file)
    users = {}
    sessions = {}
    total_sessions = 0

    File.open(file).each do |line|
      cols = line.split(',')
      if cols[0].start_with?('user')
        users[cols[1]] = parse_user(cols)
      else
        id = cols[1]
        sessions[id] ||= []
        total_sessions += 1
        sessions[id] << parse_session(cols)
      end
    end

    { users: users, sessions: sessions, total_sessions: total_sessions }
  end

  module_function :work, :parse_user, :parse_session, :user_stat, :parse_file
end
