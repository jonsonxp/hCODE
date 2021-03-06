module Pod
  class Command
    class List < Command
      self.summary = 'List hCODE projects'
      self.description = 'Lists all available hCODE projects.'

      def self.options
        [
          ['--update', 'Run `hcode repo update` before listing'],
          ['--stats',  'Show additional stats (like GitHub watchers and forks)'],
        ].concat(super)
      end

      def initialize(argv)
        @update = argv.flag?('update')
        @stats  = argv.flag?('stats')
        super
      end

      def run
        update_if_necessary!

        sets = SourcesManager.aggregate.all_sets
        sets.each { |set| UI.pod(set, :name_and_version) }
        UI.puts "\n#{sets.count} hcode projects were found"
      end

      def update_if_necessary!
        if @update && config.verbose?
          UI.section("\nUpdating Spec Repositories\n".yellow) do
            Repo.new(ARGV.new(['update'])).run
          end
        end
      end

      #-----------------------------------------------------------------------#
    end
  end
end
