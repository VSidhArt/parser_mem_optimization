# frozen_string_literal: true

require 'json'
require 'pry'
require 'date'
require 'set'

module Optimized
  class User
    attr_reader :attributes, :sessions

    def initialize(attributes:, sessions:)
      @attributes = attributes
      @sessions = sessions
    end
  end

  def parse_user(fields)
    {
      'id' => fields[1],
      'first_name' => fields[2],
      'last_name' => fields[3],
      'age' => fields[4]
    }
  end

  def parse_session(fields)
    {
      'user_id' => fields[1],
      'session_id' => fields[2],
      'browser' => fields[3],
      'time' => fields[4],
      'date' => fields[5]
    }
  end

  def user_stat(user_sessions)
    sessions_times = user_sessions.map { |s| s['time'].to_i }
    user_browsers = user_sessions.map { |s| s['browser'].upcase }.sort

    {
      'sessionsCount' => user_sessions.count,
      'totalTime' => sessions_times.sum.to_s + ' min.',
      'longestSession' => sessions_times.max.to_s + ' min.',
      'browsers' => user_browsers.join(', '),
      'usedIE' => user_browsers.any? { |b| b.match?(/INTERNET EXPLORER/) },
      'alwaysUsedChrome' => user_browsers.all? { |b| b.match?(/CHROME/) },
      'dates' => user_sessions.map { |s| s['date'] }.sort! { |a, b| b <=> a }
    }
  end

  def parse_file(file)
    users = {}
    sessions = {}
    total_sessions = 0
    file_lines = File.read(file).split("\n")

    file_lines.each do |line|
      cols = line.split(',')
      users[cols[1]] = parse_user(cols) if cols[0] == 'user'
      next unless cols[0] == 'session'

      id = cols[1]
      sessions[id] ||= []
      total_sessions += 1
      sessions[id] << parse_session(cols)
    end
    { users: users, sessions: sessions, total_sessions: total_sessions }
  end

  def work(file = 'data/data_100_000.txt')
    data = parse_file(file)

    data = parse_file(file)
    users = data[:users]
    sessions = data[:sessions]
    total_sessions = data[:total_sessions]

    report = {}

    report[:totalUsers] = users.count

    uniqueBrowsers = Set.new

    sessions.values.flatten.each do |s|
      uniqueBrowsers.add(s['browser'].upcase)
    end

    report['uniqueBrowsersCount'] = uniqueBrowsers.count

    report['totalSessions'] = total_sessions

    report['allBrowsers'] =
      sessions.values.flatten
              .map { |s| s['browser'] }
              .map(&:upcase)
              .sort
              .uniq
              .join(',')

    # Статистика по пользователям
    users_objects = []
    report['usersStats'] = {}

    users.each do |u_id, user|
      user_key = "#{user['first_name']} #{user['last_name']}"
      user_sesssions = sessions[u_id]
      report['usersStats'][user_key] = user_stat(user_sesssions)
    end

    File.write('result.json', "#{report.to_json}\n")
  end

  module_function :work, :parse_user, :parse_session, :user_stat, :parse_file
end
