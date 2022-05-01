/* character_counter_css */
.characters-remaining{
    font-size: 10px;
}

.field-spacing{
    padding: 5px 0 5px 0;
    width: 100%;
    flex-basis: 100%;
    display: block;
    border-bottom: #e5e5e5 1px solid;
}

.field-spacing .slds-form-element{
    pointer-events: none;
}

.counting-accordion button.slds-accordion__summary-action{
    background-color: #f3f3f3 !important;
}

.edit-icon-space{
    float:right;
    z-index: 999;
}

.edit-icon .slds-button__icon{
    fill: #dddbda !important;
    cursor: pointer;
}

[c-character_counter_record_view_form_character_counter_record_view_form].slds-form-element_stacked:not(.slds-is-editing){
    padding: 0 0 0 0 !important;
    margin-bottom: 0 !important;
}