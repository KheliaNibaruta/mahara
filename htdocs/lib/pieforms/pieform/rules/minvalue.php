<?php
/**
 * Pieforms: Advanced web forms made easy
 * @package    pieform
 * @subpackage rule
 * @author     Nigel McNie <nigel@catalyst.net.nz>
 * @author     Catalyst IT Limited <mahara@catalyst.net.nz>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL version 3 or later
 * @copyright  For copyright information on Mahara, please see the README file distributed with this software.
 *
 */

/**
 * Checks whether the given value is at least a certain size.
 *
 * @param Pieform $form      The form the rule is being applied to
 * @param string  $value     The value to check
 * @param array   $element   The element to check
 * @param int     $maxlength The value to check for
 * @return string            The error message, if the value is invalid.
 */
function pieform_rule_minvalue(Pieform $form, $value, $element, $minvalue) {/*{{{*/
    if ($value !== '' && doubleval($value) < $minvalue) {
        return sprintf($form->i18n('rule', 'minvalue', 'minvalue', $element), $minvalue);
    }
    return '';
}/*}}}*/
