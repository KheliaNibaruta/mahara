<?php
/**
 * Pieforms: Advanced web forms made easy
 * @package    pieform
 * @subpackage rule
 * @author     Robert Lyon <robertl@catalyst.net.nz>
 * @author     Catalyst IT Limited <mahara@catalyst.net.nz>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL version 3 or later
 * @copyright  For copyright information on Mahara, please see the README file distributed with this software.
 *
 */

/**
 * Checks whether the field has a safe text string.
 *
 * @param Pieform $form    The form the rule is being applied to
 * @param string  $value   The value of the field
 * @param array   $element The element to check
 * @param string  $check   Whether to check the element
 * @return string         The error message, if the value is invalid.
 */
function pieform_rule_safetext(Pieform $form, $value, $element, $check) {
    if ($value != '') {
        if ($value != strip_tags(clean_html($value))) {
            return $form->i18n('rule', 'safetext', 'invalidchars', $element);
        }
    }
    return '';
}
