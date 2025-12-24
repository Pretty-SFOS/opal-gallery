//@ This file is part of opal-localstorage.
//@ https://github.com/Pretty-SFOS/opal-localstorage
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2018-2025 Mirian Margiani

// TODO finish docs
// TODO add db handle to all events
// TODO enforce db handle format: /^[-0-9a-zA-Z]+$/
// TODO support db backups
// TODO support renaming a db? or in c++

.pragma library
.import QtQuick.LocalStorage 2.0 as LS

//
// GLOBAL THINGS
// LocalStorage docs namespace
//

/*!
  \qmlproperty string LocalStorage::_lc

  Logging category prefix for log messages.

  \internal
*/
var _lc = "[Opal.LocalStorage] "

/*!
  \qmltype LocalStorage
  \inqmlmodule Opal.LocalStorage

  \brief Helper for implementing a local database backend.

  \section2 Example

  \todo TODO

  \qml
  import Opal.MyModule 1.0

  // ...
  \endqml
*/

/*!
  \qmlmethod any LocalStorage::defaultFor(variable, fallback)

  Returns \a variable if it is defined. Returns \a fallback
  if \a variable is undefined.
*/
function defaultFor(variable, fallback) {
    return typeof variable !== 'undefined' ? variable : fallback
}

/*!
  \qmlmethod bool LocalStorage::isSameValue(x, y)

  This function is a polyfill for JavaScript's \c {Object.is()}
  which is not available in ancient Qt 5.6.

  Returns whether \a x and \a y are the same value.
*/
function isSameValue(x, y) {
    // Polyfill for Object.is() which is not available in ancient Qt.
    // - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
    // - https://github.com/zloirock/core-js/blob/master/packages/core-js/internals/same-value.js
    // - https://stackoverflow.com/a/48300450
    return x === y ? x !== 0 || 1 / x === 1 / y : x !== x && y !== y
}


//
// DATABASE THINGS
// Database docs namespace
//

/*!
  \qmltype Database
  \inqmlmodule Opal.LocalStorage
  \since version 0.3.0

  \brief Database class representing a local storage database.

  \section2 Example

  \todo TODO

  \code
  // ...
  \endcode
*/

/*!
  \qmlproperty function LocalStorage::_DB_STATUS_SIGNAL

  This function will be called when the database must notify
  of events. It gets a QML signal assigned in the \l MessageHandler,
  where internal events are handled.

  The signal handler function must not access the database to avoid
  the possibility of calling it recursively.

  \b {Signal arguments:}

  \value {string event}   which event occurred
  \value {string handle}  unique ID identifying the event
  \value {bool busy}      \c true if the event is a running process
  \value {object data}    additional details about the event

  \b {Long running processes:}

  Events that take time send a busy signal and save the returned
  handle. When they end, they send the \c end signal with the
  previous handle.

  \defaultValue null

  \sa Database::_notify, Database::_notifyEnd, MessageHandler

  \internal
*/
var _DB_STATUS_SIGNAL = null

/*!
  \qmlproperty int LocalStorage::_EVENT_COUNTER

  This property counts how many internal events have been sent overall.
  It is used for generating unique event handles.

  \internal
*/
var _EVENT_COUNTER = 1

/*!
  \qmlproperty int LocalStorage::_USER_EVENT_COUNTER

  This property counts how many user events have been sent overall.
  It is used for generating unique event handles.

  \internal
*/
var _USER_EVENT_COUNTER = 1

/*!
  \qmlproperty int LocalStorage::_DATABASE_COUNTER

  This property counts how many databases have been sent created.
  It is used for generating unique database handles if no handle is provided
  on creation.

  \internal
*/
var _DATABASE_COUNTER = 0

/*!
  \qmlmethod void Database::Database(string handle, string name, string description)

  The database constructor creates and returns a new \l Database object.

  Database configuration can then be changed on the new object. The database is
  only initialized on the first actual request, i.e. when \l Database::simpleQuery,
  \l Database::getDatabase, or a function callig either of these methods is called.

  Provide a unique string as \a handle to identify the database later. This is
  used in events (see \l Database::notify) to determine the origin of an event.

  Provide a \a name and an optional \a description. The \a name is used to
  generate the file name of the actual database file. It cannot be changed again
  after creating the database.

  Set the \l migrations property on the new object to define the database schema.

  \note the values of the arguments passed to the constructor cannot be changed
  again! The database name is used to generate the actual database file name.

  \sa migrations, simpleQuery, notify
*/
function Database(handle, name, description) {
    _DATABASE_COUNTER++

    // Internal logging helpers
    var _lc_db = _lc + "[DB " + handle + "]"
    this._log = console.log.bind(console, _lc_db)
    this._warn = console.warn.bind(console, _lc_db)
    this._error = console.error.bind(console, _lc_db)

    /*!
      \qmlproperty string Database::handle

      This property defines a string to identify a database object.
      The handle should be unique but this is not enforced.

      The handle is used to determine the origin of storage events.

      \sa notify, notifyEnd
    */
    this.handle = defaultFor(handle, String(_DATABASE_COUNTER))

    /*!
      \qmlproperty string Database::name

      This property holds the name of this database.

      The value is defined when calling the constructor and cannot be changed
      after the database has been created.

      \defaultValue {My Database}
    */
    this.name = defaultFor(name, "My Database")

    /*!
      \qmlproperty string Database::description

      This property holds the optional description of this database.

      The value is defined when calling the constructor and cannot be changed
      after the database has been created.

      \defaultValue
     */
    this.description = defaultFor(description, "")

    /*!
      \qmlproperty bool Database::isOk

      This property shows whether the database is currently in a
      usable state. This will be set to \c false after a fatal
      error like a failed migration occurred.

      \defaultValue {true}
    */
    this.isOk = true

    /*!
      \qmlproperty list Database::migrations

      Database migrations to setup the database, and later to
      convert the database from one version to another.

      This property is a list of migrations. Each migration is
      a list with two entries:

      \table
        \header
            \li index
            \li type
            \li description

        \row
            \li 0
            \li \c int
            \li target version, e.g. \c 1 for the initial version.

        \row
            \li 1
            \li \c string or \c function
            \li the migration, see below.
      \endtable

      \section2 Migration string:

      \table
        \row
            \li 1
            \li \c string
            \li migration query, like \c {'CREATE TABLE IF NOT EXISTS myTable(foo);'}.
      \endtable

      For very simple migrations you can pass a single SQLite statement as the
      migration body. Note that this will fail if the string contains more than
      one query.

      \section2 Migration function:

      \table
        \row
            \li 1
            \li \c function
            \li migration function, like \c function(tx){}.
      \endtable

      More complex migrations use a migration function.

      The migration function takes a transaction object \c tx as its only
      paramenter. See Qt's Local Storage documentation for details
      on how to use transaction objects.

      You must only use \c {tx.executeSql(...)} in migration functions.
      Methods like \l simpleQuery or \l guardedTx will not work.

      \section2 Considerations:

      \note migrations will run when the database is being initialized.
      That is, in the first call to \l simpleQuery or \l getDatabase
      (or any method that uses either of those functions).

      \note remember: versions must be numeric. Integers or decimal
      values (\c 1 or \c 0.1) are allowed but not something like
      \c {0.1.1}.

      \section2 Example:

      \code
      var DB = new Database('db')

      DB.migrations = [
          [1, function(tx){
              tx.executeSql('\
                  CREATE TABLE IF NOT EXISTS projects(
                      id INTEGER PRIMARY KEY,
                      name TEXT,
                      owner TEXT
                  )
              ;')
          }],
          [2, function(tx){
              tx.executeSql('ALTER TABLE projects DROP COLUMN owner;')
          }],

          // add new versions here...
      ]
      \endcode

      \defaultValue []
    */
    this.migrations = []

    /*!
      \qmlproperty bool Database::enableAutoMaintenance

      This property defines whether database maintenance will be run
      automatically in regular intervals.

      By default, this includes only running \c VACUUM on the
      database. A custom maintenance function can be assigned to
      \l maintenanceCallback which will then run together with the
      default maintenance.

      The interval can be set in \l maintenanceInterval.

      \defaultValue true

      \sa maintenanceInterval, maintenanceCallback
    */
    this.enableAutoMaintenance = true

    /*!
      \qmlproperty int Database::maintenanceInterval

      This property defines how often the automatic database maintenance
      will be run if \l enableAutoMaintenance is \c true.

      The value is the number of days between maintenance jobs. If the database
      is heavily used with lots of deletions, prefer to set this to a lower
      value.

      \defaultValue 60

      \sa enableAutoMaintenance, maintenanceCallback
    */
    this.maintenanceInterval = 60

    /*!
      \qmlproperty function Database::maintenanceCallback

      This property defines a custom maintenance function that will be executed
      during automatic database maintenance if \l enableAutoMaintenance is \c true.

      The function takes no arguments and can use regular database functions
      (\l simpleQuery, \l guardedTx, etc.) to access the database.

      \defaultValue null

      \sa enableAutoMaintenance, maintenanceInterval
    */
    this.maintenanceCallback = null

    /*!
      \qmlproperty string Database::settingsTable

      This property holds the name of the internally managed settings table.

      The \l Database class provides easy settings handling through a key-value
      store in this table. The table name can be changed here initially.
      The table is created automatically when the database is first created,
      before any migrations are run.

      \section2 Columns:

      \value key   \c {TEXT UNIQUE}
      \value value \c {TEXT}

      \defaultValue value
    */
    this.settingsTable = "__local_settings"

    // Estimated size of the database in bytes. Currently unused by Qt.
    this._expectedSize = 2000000  // ~2 MB but this is ignored by Qt anyway

    // Whether the database has been successfully initialized. Stays \c false
    // if initialization fails (setup, migrations, etc.).
    this.__initialized = false

    // The actual QtQuick.LocalStorage database object.
    this.__db = null

    // Internal notification function.
    // Use the public function instead for user events.
    this._notify = (function(event, busy, data, __handle) {
        if (!__handle) {
            _EVENT_COUNTER++
            __handle = _EVENT_COUNTER
        }

        this._log("event:", event, "[" + __handle + "]",
                    (busy ? " (busy)" : ""),
                    !!data ? JSON.stringify(data) : "")

        if (_DB_STATUS_SIGNAL instanceof Function) {
            try {
                _DB_STATUS_SIGNAL(event, String(__handle), busy, data)
            } catch(e) {
                this._error("sending the status signal failed:",
                            "\n   ERROR  >", e,
                            "\n   STACK  >\n", e.stack)
            }
        }

        return __handle
    }).bind(this)

    // Internal notification function.
    // Use the public function instead for user events.
    this._notifyEnd = (function(handle) {
        this._notify("end", false, null, handle)
    }).bind(this)

    /*!
      \qmlmethod void Database::notify(string event, bool busy, object data)

      This method allows sending custom events to the \l MessageHandler, which
      can then be handled in QML.

      The event name is sent as a string in the \a event parameter.

      This method returns a unique handle to identify this event.
      Long running processes can use the \l notifyEnd method to send the special
      \c end event together with the handle of the event that started a process.
      Use this to e.g. to hide an overlay once a process is finished.

      The boolean \a busy parameter can be used to indicate whether an event is
      a process or a one-shot event.

      In the \a data parameter, you can send any additional data that
      can then be handled in the signal handler.

      \sa notifyEnd, MessageHandler, MessageHandler::showOverlay
    */
    this.notify = (function(event, busy, data) {
        _USER_EVENT_COUNTER++
        var handle = String("user-%1").arg(_USER_EVENT_COUNTER)
        return this._notify(event, busy, data, handle)
    }).bind(this)

    /*!
      \qmlmethod void Database::notifyEnd(string handle)

      This method sends the special \c end event for a previously sent event
      with the handle \a handle. The handle of an event is returned by the
      \l notify method when sending an event.

      The \c end event can then be handled in QML in the \l MessageHandler.
      Use this to e.g. to hide an overlay once a process is finished.

      \sa notify, MessageHandler, MessageHandler::hideOverlay
    */
    this.notifyEnd = (function(handle) {
        this._notify("end", false, null, handle)
    }).bind(this)

    /*!
      \qmlmethod DB Database::getDatabase()

      This function returns the actual \l QtQuick.LocalStorage database object
      that is managed in this \l Database.

      Read the documentation for \l QtQuick.LocalStorage for details on how
      to use this.

      \note this gives you full access to the internal database. It is usually
      not necessary to call this method. Instead, prefer to use \l simpleQuery,
      \l readQuery, and \l guardedTx to access the database.

      Returns the internal database object.
    */
    this.getDatabase = (function() {
        if (!this.isOk) {
            this._error("database is not available, check previous logs")
            throw new Error("database is not available, check previous logs")
        }

        if (!this.__initialized || this.__db === null) {
            this._log("initializing database...")
            this.__db = LS.LocalStorage.openDatabaseSync(
                this.name, "", this.description, this._expectedSize)

            if (this.__doInit(this.__db)) {
                this.__initialized = true
                this.isOk = true

                if (this.enableAutoMaintenance) {
                    this.__doDatabaseMaintenance()
                }
            } else {
                this.isOk = false
            }
        }

        return this.__db
    }).bind(this)

    /*!
      \qmlmethod object Database::guardedTx(transaction tx, function callback)

      This function runs a function \a callback in a transaction \a tx and performs
      a safe rollback if the callback throws an exception, e.g. if a query fails.

      Callback is a function that takes the transaction as its only argument
      (\c {function callback(tx){}}).

      \note the callback may only use direct methods of \a tx. Database functions
      like \l simpleQuery are not allowed in the callback.

      Returns the result of calling \a callback or \c null if the call failed.

      \sa simpleQuery
    */
    this.guardedTx = (function(tx, callback) {
        var res = null

        try {
            tx.executeSql('SAVEPOINT __guarded_tx_started__;')
            res = callback(tx)
            tx.executeSql('RELEASE __guarded_tx_started__;')
        } catch (e) {
            tx.executeSql('ROLLBACK TO __guarded_tx_started__;')

            this._error("guarded transaction failed:",
                        "\n   ERROR  >", e,
                        "\n   CALLER >", e.stack)
            throw e
        }

        return res
    }).bind(this)

    /*!
      \qmlmethod object Database::readQuery(string query, list values)

      This function performs a read-only \a query on the database, with optional
      values bound to the array \a values.

      Only \c SELECT statements are allowed in read-only queries.

      See \l simpleQuery for details.

      Returns a result object.

      \sa simpleQuery
    */
    this.readQuery = (function(query, values) {
        return this.simpleQuery(query, values, true)
    }).bind(this)

    /*!
      \qmlmethod object Database::simpleQuery(string query, list values, bool readOnly)

      This function performs a safe query on the database. Any changes will be
      rolled back if the query fails.

      The query \a query must be a single SQLite statement. It will fail if
      more than one statement is passed in a single call.

      The list of \a values will be bound to SQL positional parameters (marked
      with “\c {?}” placeholders.)

      A read-only query will be performed if \a readOnly is \c true. This is
      only allowed for \c SELECT statements. See \l readQuery.

      This method returns a result object with the following properties:

      \table
        \header
            \li type
            \li property
            \li description
            \li applicability

        \row
            \li \c bool
            \li ok
            \li set to \c true if the query was successful
            \li all

        \row
            \li \c int
            \li rowsAffected
            \li the number of rows affected by the query
            \li UPDATE, DELETE

        \row
            \li \c int
            \li insertId
            \li the ID of the row that was inserted
            \li INSERT

        \row
            \li \c var
            \li rows
            \li the selected rows
            \li SELECT

        \row
            \li \c int
            \li rows.length
            \li the number of rows in the result set
            \li SELECT


        \row
            \li \c var
            \li rows.item(i)
            \li returns the row \c i of the result set, fields are accessed as properties
            \li SELECT
      \endtable

      \section2 Considerations:

      The \l QtQuick.LocalStorage implementation does not perform rollbacks
      on failed transactions, contrary to what is stated in its documentation.

      You can safely use \l simpleQuery which handles errors and rollbacks
      properly. Check the implementation and use \l guardedTx in custom transactions.

      This is the case in Qt 5.6 (Sailfish 4.6) but the code has not changed
      at least until Qt 6.8. That means manual guarding is necessary: every
      transaction must be enclosed in a \c throw / \c catch block and perform
      either \c ROLLBACK or \c {SAVEPOINT <name>} with \c {ROLLBACK TO <name>}
      when needed. \l simpleQuery and \l guardedTx handle this for you.

      \section2 Error handling:

      If a query fails, a default result object is returned:

      \value ok \c false
      \value rowsAffected \c 0
      \value insertId \c null
      \value rows \c []

      Also, an internal event is dispatched. Setup \l MessageHandler to handle
      this event.

      \sa QtQuick.LocalStorage, guardedTx
    */
    this.simpleQuery = (function(query, values, readOnly) {
        var db = this.getDatabase()
        var res = {
            ok: false,
            rowsAffected: 0,
            insertId: null,
            rows: []
        }

        values = defaultFor(values, [])

        if (!query) {
            this._error("bug: cannot execute an empty database query")
            return res
        }

        try {
            var callback = (function(tx) {
                var rs = null

                if (readOnly === true) {
                    // Rollbacks are only possible and sensible
                    // in read-write transactions. It is necessary
                    // to skip guardedTx() here.
                    rs = tx.executeSql(query, values)
                } else {
                    rs = this.guardedTx(tx, (function(tx){
                        return tx.executeSql(query, values)
                    }).bind(this))
                }

                if (rs.rowsAffected > 0) {
                    res.rowsAffected = rs.rowsAffected
                } else {
                    res.rowsAffected = 0
                }

                res.insertId = defaultFor(rs.insertId, null)
                res.rows = rs.rows
            }).bind(this)

            if (readOnly === true) {
                db.readTransaction(callback)
            } else {
                db.transaction(callback)
            }

            res.ok = true
        } catch(e) {
            this._error((readOnly === true ? "read-only " : "") + "database query failed:",
                        "\n   ERROR  >", e,
                        "\n   QUERY  >", query,
                        "\n   VALUES >", values)
            this._notify("query-failed", false, {
                exception: e,
                query: query,
                values: values,
                readOnly: readOnly
            })
            res.ok = false
        }

        return res
    }).bind(this)

    /*!
      \qmlmethod void Database::setSetting(string key, string value)

      This function saves a setting with key \a key and value \a value to the
      settings table.

      \sa settingsTable
    */
    this.setSetting = (function(key, value) {
        this.simpleQuery('INSERT OR REPLACE INTO %1 VALUES (?, ?);'.arg(this.settingsTable), [key, value])
    }).bind(this)

    /*!
      \qmlmethod void Database::getSetting(string key, string fallback)

      This function returns the value of a setting with key \a key from the
      settings table, or \a fallback if no such key is found.

      \sa settingsTable, setSetting
    */
    this.getSetting = (function(key, fallback) {
        var res = this.simpleQuery('SELECT value FROM %1 WHERE key=? LIMIT 1;'.arg(this.settingsTable), [key])

        if (res.rows.length > 0) {
            res = defaultFor(res.rows.item(0).value, fallback)
        } else {
            res = fallback
        }

        return res
    }).bind(this)

    /*!
      \qmlmethod void Database::createSettingsTable(transaction tx)

      This function creates the internally managed settings table. For new
      databases, it is not necessary to call this method manually. The settings
      table is created automatically for you when a database is first created.

      When converting a custom database system to use \l Opal.LocalStorage, you
      must make sure that the settings table exists:

      \code
      var DB = new Database('db')

      DB.migrations = [
          // ... migrations ...

          [2, function(tx){
              // prepare the new settings table:
              tx.executeSql('DROP TABLE IF EXISTS %1;'.arg(DB.settingsTable));
              DB.createSettingsTable(tx);

              // optionally import existing settings into the new settings table:
              tx.executeSql('INSERT INTO %1(key, value) \
                  SELECT setting, value FROM myOldSettingsTable;'.arg(DB.settingsTable))
              tx.executeSql('DROP TABLE settings_table;');
          }],

          // ... more migrations ...
      ]
      \endcode

      This function takes a transaction \a tx to create the new settings table.

      \sa getSetting, setSetting, settingsTable, migrations
    */
    this.createSettingsTable = (function(tx) {
        // TODO error handling?
        this.guardedTx(tx, (function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS %1 (key TEXT UNIQUE, value TEXT);'.arg(this.settingsTable))
        }).bind(this))
    }).bind(this)

    /*!
      \qmlmethod void Database::makeTableSortable(transaction tx, string tableName, string orderColumn)

      \warning this function is experimental!

      This function sets up a table to automatically update an ordering column.
      It does so by creating a view on the table with triggers that handle updating
      the ordering column.

      \section2 Usage:

      Manually create a table that has at least one content column (any type)
      and one order column (\c INTEGER). Then call this function with the new table's
      name in the \a tableName parameter, and the name of the order column in the
      \a orderColumn parameter.

      \note the table name must start with an underscore (“\c {_}”). The view
      created by this function has the same name without the underscore:
      if \a tableName is \c _myTable, then the view is \c myTable.

      After calling this function, the table must not be used directly anymore,
      \b only the view that is created by this function.

      \note this function must be called again after modifying
      the table schema in migrations.

      \table
        \header
            \li parameter
            \li type
            \li description

        \row
            \li \a tx
            \li \c transaction
            \li database transaction

        \row
            \li \a tableName
            \li \c string
            \li name of the already existing table that should be managed.
            It must be a string starting with an underscore (“\c {_}”). It must have
            at least one content column (any type) and one order column (type \c INTEGER).

        \row
            \li \a orderColumn
            \li \c string
            \li name of the column that stores the order of entries.
            The column must be of type \c INTEGER.
      \endtable

      \warning never call this function outside of a migration!

      \section2 Warnings:

      \list
        \li The parameters are not thoroughly verified before they are
            used to build SQL queries. Mistakes can destroy your database.
        \li Order values start at 1.
        \li Invalid order values (\c 0, \c {< 0}, \c {> count}) will raise an exception.
            Use \c NULL as order to insert a row at the end.

      \sa migrations
    */
    this.makeTableSortable = (function(tx, tableName, orderColumn) {
        // The implementation is based on \l https://stackoverflow.com/a/19976918
        // (\c LS_dev, CC-BY-SA-3.0).

        if (!(!!tableName) || typeof tableName != "string" || false) {
            throw new Error("Table name must be a string starting with " +
                            "an underscore ('_'), got '%1'".arg(tableName))
        }

        var viewName = tableName.toString().slice(1)

        if (!(!!orderColumn) || typeof orderColumn != "string") {
            throw new Error("Order column must be a string, got '%1'".arg(orderColumn))
        }

        var columns = []
        var rs = tx.executeSql('SELECT name FROM pragma_table_info("%1") as info;'.arg(tableName))

        for (var i = 0; i < rs.rows.length; ++i) {
            var name = rs.rows.item(i).name.toString()

            if (name !== orderColumn) {
                columns.push(name)
            }
        }

        if (columns.length === 0) {
            throw new Error("Table '%1' must have at least one column " +
                            "other than the order column".arg(tableName))
        }

        var columnsString = columns.join(', ')
        var newColumnsString = 'NEW.' + columns.join(', NEW.')

        // Table view, which will handle all inserts, updates and deletes
        tx.executeSql('\
            CREATE VIEW %1 AS SELECT * FROM %2;
        '.arg(viewName).arg(tableName))

        // Triggers:
        // Raise error when inserting invalid index (out of bounds or non integer)
        tx.executeSql('\
            CREATE TRIGGER %1_ins_err INSTEAD OF INSERT ON %1
            WHEN NEW.%3 < 1 OR NEW.%3 > (SELECT COUNT()+1 FROM %2) OR CAST(NEW.%3 AS INT) <> NEW.%3
            BEGIN
                SELECT RAISE(ABORT, "Invalid index!");
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn))

        // Increments all indexes when new row inserted in middle of table
        //
        // not possible:   INSERT INTO %2 SELECT * FROM NEW;
        // https://sqlite.org/forum/info/320a27de1cfb0dfb
        tx.executeSql('\
            CREATE TRIGGER %1_ins INSTEAD OF INSERT ON %1
            WHEN NEW.%3 BETWEEN 1 AND (SELECT COUNT() FROM %2)+1
            BEGIN
                UPDATE %2 SET %3 = %3 + 1 WHERE %3 >= NEW.%3;
                INSERT INTO %2(%4, %3) VALUES(%5, NEW.%3);
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn).arg(columnsString).arg(newColumnsString))

        // Insert row in last when supplied index is NULL
        tx.executeSql('\
            CREATE TRIGGER %1_ins_last INSTEAD OF INSERT ON %1
            WHEN NEW.%3 IS NULL
            BEGIN
                INSERT INTO %2(%4, %3) VALUES(%5, (SELECT COUNT()+1 FROM %2));
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn).arg(columnsString).arg(newColumnsString))

        // Decrements indexes when item is removed
        tx.executeSql('\
            CREATE TRIGGER %1_del INSTEAD OF DELETE ON %1
            BEGIN
                DELETE FROM %2 WHERE %3 = OLD.%3;
                UPDATE %2 SET %3 = %3 - 1 WHERE %3>OLD.%3;
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn))

        // Raise error when updating to invalid index
        tx.executeSql('\
            CREATE TRIGGER %1_upd_err INSTEAD OF UPDATE OF %3 ON %1
            WHEN NEW.%3 NOT BETWEEN 1 AND (SELECT COUNT() FROM %2) OR CAST(NEW.%3 AS INT)<>NEW.%3 OR NEW.%3 IS NULL
            BEGIN
                SELECT RAISE(ABORT, "Invalid index!");
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn))

        // Decrements indexes when item is moved up
        tx.executeSql('\
            CREATE TRIGGER %1_upd_up INSTEAD OF UPDATE OF %3 ON %1
            WHEN NEW.%3 BETWEEN OLD.%3+1 AND (SELECT COUNT() FROM %2)
            BEGIN
                UPDATE %2 SET %3 = NULL WHERE %3 = OLD.%3;
                UPDATE %2 SET %3 = %3 - 1 WHERE %3 BETWEEN OLD.%3 AND NEW.%3;
                UPDATE %2 SET %3 = NEW.%3 WHERE %3 IS NULL;
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn))

        // Increments indexes when item is moved down
        tx.executeSql('\
            CREATE TRIGGER %1_upd_down INSTEAD OF UPDATE OF %3 ON %1
            WHEN NEW.%3 BETWEEN 1 AND OLD.%3-1
            BEGIN
                UPDATE %2 SET %3 = NULL WHERE %3 = OLD.%3;
                UPDATE %2 SET %3 = %3 + 1 WHERE %3 BETWEEN NEW.%3 AND OLD.%3;
                UPDATE %2 SET %3 = NEW.%3 WHERE %3 IS NULL;
            END;
        '.arg(viewName).arg(tableName).arg(orderColumn))
    }).bind(this)

    /*!
     * \qmlmethod bool Database::__doInit(db)
     *
     * This function initializes the database.
     * The \a db parameter is a \l QtQuick.LocalStorage database.
     *
     * Returns \c true on success, \c false otherwise.
     *
     * \internal
     */
    this.__doInit = (function(db) {
        // Due to https://bugreports.qt.io/browse/QTBUG-71838 which was fixed only
        // in Qt 5.13, it's not possible the get the actually current version number
        // from the database object after a migration. The db.version field always
        // stays at the initial version. Instead of reopening the database and
        // replacing the db object, we track the current version manually when
        // applying migrations (previousVersion).
        //
        // However, db.changeVersion(from, to) expects the same version as stored in
        // the database object as "from" parameter. This means that calls to
        // changeVersion must use db.version as the first argument and not the correct
        // version number. When a migration fails, it is important to roll back to
        // the version the database is actually on, i.e. the manually tracked version.
        // That means a last call to changeVersion(db.version, previousVersion) is
        // necessary.
        //
        // Furthermore, QtQuick.LocalStorage does not perform rollbacks
        // on failed transactions, contrary to what is stated in the documentation.
        // See the docs on simpleQuery() for details.

        var latestVersion = 0

        if (this.migrations.length > 0) {
            latestVersion = this.migrations[this.migrations.length-1][0]
        }

        var initialVersion = db.version
        var previousVersion = Number(initialVersion || "0")
        var nextVersion = null
        var handle = null
        var upgradesOk = true

        if (initialVersion === "") {
            this._log("initializing new database:", this.name, "|", this.handle)
            db.transaction(this.createSettingsTable)
            handle = this._notify("init", true)
        } else if (!!latestVersion && initialVersion < latestVersion) {
            handle = this._notify("upgrade", true,
                                  {from: initialVersion, to: latestVersion})
        } else if (!!latestVersion && initialVersion !== String(latestVersion)) {
            handle = this._notify("invalid-version", false,
                                  {got: initialVersion, expected: latestVersion})
            return false
        }

        if (initialVersion !== String(latestVersion)) {
            for (var i in this.migrations) {
                nextVersion = this.migrations[i][0]

                if (previousVersion < nextVersion) {
                    try {
                        this._log("migrating database to version", nextVersion)

                        db.changeVersion(db.version, nextVersion, (function(tx){
                            this.guardedTx(tx, (function(tx){
                                var migrationType = typeof this.migrations[i][1]
                                if (migrationType === "string") {
                                    tx.executeSql(this.migrations[i][1])
                                } else if (migrationType === "function") {
                                    this.migrations[i][1](tx)
                                } else {
                                    throw new Error("expected migration as string or function, got " +
                                                    migrationType + " instead")
                                }
                            }).bind(this))
                        }).bind(this))
                    } catch (e) {
                        this._error("fatal: failed to upgrade database version from",
                                    previousVersion, "to", nextVersion)
                        this._error("exception:\n", e)
                        db.changeVersion(db.version, previousVersion, function(tx){})
                        this._notify("upgrade-failed", false,
                                     {from: previousVersion, to: nextVersion,
                                      exception: e})
                        upgradesOk = false
                        break
                    }

                    previousVersion = nextVersion
                }
            }
        }

        if (!!handle) {
            this._notifyEnd(handle)
        }

        if (!upgradesOk) {
            this._log("cannot load database due to previous errors")
            return false
        } else if (previousVersion !== latestVersion) {
            this._error("fatal: expected database version",
                        String(latestVersion),
                        "but loaded database has version", previousVersion)
            this._notify("invalid-version", false,
                         {got: initialVersion, expected: latestVersion})
            return false
        }

        this._log("loaded database version", previousVersion)

        return true
    }).bind(this)

    // Vacuum the database. Internally called on maintenance.
    this.__vacuumDatabase = (function() {
        var db = this.getDatabase()

        try {
            db.transaction(function(tx) {
                // VACUUM cannot be executed inside a transaction, but the LocalStorage
                // module cannot execute queries without one. Thus we have to manually
                // end the transaction from inside the transaction.
                tx.executeSql("END TRANSACTION;")
                tx.executeSql("VACUUM;")
            })
        } catch(e) {
            this._error("database vacuuming failed:\n", e)
        }
    }).bind(this)

    // Run database maintenance. Automatically called if enableAutoMaintenance
    // is true. Calls maintenanceCallback before calling __vacuumDatabase.
    this.__doDatabaseMaintenance = (function() {
        var interval = String(Number(this.maintenanceInterval))

        if (!/^[1-9]+[0-9]*$/.test(interval)) {
            interval = '60'  // default maintenance interval
        }

        var last_maintenance = this.simpleQuery(
            'SELECT * FROM %1 WHERE key = "last_maintenance" \
                 AND value >= date("now", "-%2 day") LIMIT 1;'.
                    arg(this.settingsTable).arg(interval),
            [], true)

        if (last_maintenance.rows.length > 0) {
            return
        }

        this._log("running regular database maintenance...")

        var handle = this._notify("maintenance", true)

        if (this.maintenanceCallback instanceof Function) {
            try {
                this.maintenanceCallback()
            } catch(e) {
                this._error("custom database maintenance failed:",
                            "\n   ERROR  >", e,
                            "\n   STACK  >\n", e.stack)
            }
        }

        this.__vacuumDatabase()

        this._log("maintenance finished")
        this.setSetting("last_maintenance", new Date().toISOString())

        this._notifyEnd(handle)
    }).bind(this)
}
