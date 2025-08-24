<?php
/**
 * phpMyAdmin configuration file
 */

declare(strict_types=1);

/**
 * This is needed for cookie based authentication to encrypt password in
 * cookie. Needs to be 32 chars long.
 */
$cfg['blowfish_secret'] = 'H2OxcGXxflSd8JwrwVlh6KW6s2rER63j';

/**
 * Server configuration
 */
$i = 0;

/**
 * First server
 */
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'mariadb';
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;

/**
 * phpMyAdmin configuration storage settings.
 */

/**
 * Directories for saving/loading files from server
 */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

/**
 * Whether to display icons or text or both icons and text in table row
 * action segment. Value can be either of 'icons', 'text' or 'both'.
 */
$cfg['RowActionType'] = 'icons';

/**
 * Defines whether a user should be displayed a "show all (records)"
 * button in browse mode or not.
 */
$cfg['ShowAll'] = false;

/**
 * Number of rows displayed when browsing a result set.
 */
$cfg['MaxRows'] = 25;

/**
 * Disallow editing of binary fields
 */
$cfg['ProtectBinary'] = false;

/**
 * Default language to use, if not browser-defined or user-defined
 */
$cfg['DefaultLang'] = 'en';

/**
 * How many columns should be used for table display of a database?
 */
$cfg['PropertiesNumColumns'] = 1;

/**
 * Set to true if you want DB-based query history.
 */
$cfg['QueryHistoryDB'] = false;

/**
 * When using DB-based query history, how many entries should be kept?
 */
$cfg['QueryHistoryMax'] = 25;

/**
 * Whether or not to query the user before sending the error report to
 * the phpMyAdmin team when a JavaScript error occurs
 */
$cfg['SendErrorReports'] = 'ask';
?>
