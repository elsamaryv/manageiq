module ActiveRecord
  class Base
    include Vmdb::Logging

    # Truncates the table.
    #
    # ==== Example
    #
    #   Post.truncate
    def self.truncate
      connection.truncate(table_name, "#{name} Truncate")
    end

    def self.reindex
      _log.info("Reindexing table #{reindex_table_name}")
      result = connection.reindex_table(reindex_table_name)
      _log.info("Completed Reindexing of table #{reindex_table_name} with result #{result.result_status}")
    end

    def self.reindex_table_name
      table_name
    end

    def self.vacuum
      _log.info("Vacuuming table #{table_name}")
      result = connection.vacuum_analyze_table(table_name)
      _log.info("Completed Vacuuming of table #{table_name} with result #{result.result_status}")
    end

    CONNECTIVITY_ERRORS = [ActiveRecord::ConnectionNotEstablished, ActiveRecord::DatabaseConnectionError, ActiveRecord::NoDatabaseError, PG::ConnectionBad].freeze

    def self.connectable?
      with_connection { |conn| conn.connect! && conn.connected? }
    rescue *CONNECTIVITY_ERRORS
      false
    end
  end
end
