<?php
/**
 *
 * @package    mahara
 * @subpackage core
 * @author     Catalyst IT Ltd
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL version 3 or later
 * @copyright  For copyright information on Mahara, please see the README file distributed with this software.
 *
 */

defined('INTERNAL') || die();

$config = new stdClass();

// See https://wiki.mahara.org/wiki/Developer_Area/Version_Numbering_Policy
// For upgrades on dev branches, increment the version by one. On main, use the date.

$config->version = 2022032213;
$config->series = '22.04';
$config->release = '22.04.3';
$config->minupgradefrom = 2020013006;
$config->minupgraderelease = '20.04.0 (release tag 20.04.0_RELEASE)';
