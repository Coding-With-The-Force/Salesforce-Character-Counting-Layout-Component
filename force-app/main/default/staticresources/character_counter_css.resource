/*
@description: This style sheet was created for the character_counting_component and its subcomponents. It should be
loaded into the character_counter_component lwc for the character counter to display itself properly. All css changes should
ideally be made here to retain consistency between the various views of the component.

@author: Matt Gerry (codingwiththeforce@gmail.com)

@date: 5/3/2022
*/

.characters-remaining, .characters-remaining-red{
    font-size: 10px;
    padding: 0.25rem;
}

.counting-accordion .slds-accordion__section{
    background-color: rgb(255, 255, 255);
}

.characters-remaining-red{
    color: red;
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

.column-class:hover svg{
    fill: gray !important;
}

.card-background .slds-card__header{
    background-color: #f3f3f3 !important;
    padding: 10px !important;
    border: #e5e5e5 1px solid !important;
    border-radius: 0.25rem;
}

.card-background .slds-card{
    border: #e5e5e5 1px solid !important;
}

.card-background .slds-card__body{
    margin: 10px !important;
}

.inline-grid{
    display: inline-grid;
}
