ENV['DATADOG_HOST'] = 'https://api.datadoghq.eu'

require 'dogapi'
require 'json'
require 'fileutils'
require 'logger'
require 'pry'

class Management # rubocop:todo Style/Documentation
  def initialize(team, apikey, appkey)
    @team = team
    @appkey = appkey
    @apikey = apikey
    @dog = Dogapi::Client.new(@apikey, @appkey)
    @logger = Logger.new(STDOUT)
  end

  def status
    @logger.debug('Datadog status')
    @logger.debug("The status for #{@team}")
    @logger.debug("Application Key: #{@appkey}")
    @logger.debug("API Key: #{@apikey}")
    @logger.debug('')
  end

  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def backup_screenboards(backupdir, backupdate)
    @logger.info("Backing up screenboards for team \'#{@team}\'")
    @screenboards = @dog.get_all_screenboards[1]['screenboards']
    @screenboards.each do |screenboard|
      @logger.info("  Processing \'#{screenboard['title']}\'")
      filename = "#{screenboard['title'].gsub(%r{[/]}, '_')}.json"
      backup_path = "#{backupdir}/#{@team}/#{backupdate}/screenboards/"
      backup_full_path = "#{backupdir}/#{@team}/#{backupdate}/screenboards/#{filename}"

      @logger.info("    Backup file \'#{backup_full_path}\'")
      FileUtils.mkdir_p(backup_path)
      content = JSON.pretty_generate(@dog.get_screenboard(screenboard['id'])[1])
      File.write(backup_full_path, content)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def backup_dashboards(backupdir, backupdate)
    @logger.info("Backing up dashboards for team \'#{@team}\'")
    dashboards = @dog.get_dashboards[1]['dashes']
    dashboards.each do |dashboard|
      filename = "#{dashboard['title'].gsub(%r{[/]}, '_')}.json"
      backup_path = "#{backupdir}/#{@team}/#{backupdate}/dashboards/"
      backup_full_path = "#{backup_path}/#{filename}"

      @logger.info("  Processing \'#{dashboard['title']}\'")
      @logger.info("    Backup file  \'#{backup_full_path}\'")
      FileUtils.mkdir_p(backup_path)
      content = JSON.pretty_generate(@dog.get_dashboard(dashboard['id'])[1])
      File.write(backup_full_path, content)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def backup_monitors(backupdir, backupdate)
    @logger.info("Backing up monitors for team \'#{@team}\''")
    page = 0
    monitors = []
    loop do
      puts page
      data = @dog.search_monitors(per_page: 100, page: page)[1]['monitors']
      (monitors << data) && page += 1
      break if data.size == 0
    end
    monitors.flatten!
    monitors.each do |monitor|
      filename = "#{monitor['name'].gsub(%r{[/]}, '_')}.json"
      backup_path = "#{backupdir}/#{@team}/#{backupdate}/monitors/"
      backup_full_path = "#{backup_path}/#{filename}"

      @logger.info("  Processing \'#{monitor['name']}\'")
      @logger.info("    Backup file #{backup_full_path}")
      FileUtils.mkdir_p(backup_path)
      content = JSON.pretty_generate(@dog.get_monitor(monitor['id'])[1])
      File.write(backup_full_path, content)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
