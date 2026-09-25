# Good tagging practices

The **Google Tag Manager** follows its own taxonomy for the nomenclature of events to be sent to the platform.

It is necessary during development to carry out the proper treatment of this data in the ***middleware*** so that it correctly reaches the GTM connector or sends the event already with the specified conventions.

Some of these conventions are listed below:

## Name of events

The names of the events to be sent (***pageview***, ***event***) are handled by the connector itself, which is in charge of making this abstraction and sending the data with the correct convention, so you just have to make sure that:

- **error** events are sent with the ***isError*** property as **true**, from this they will be renamed to ***errorGA***;
- **interaction** events must have the ***action*** property set, this way it will be reset to ***eventGA***;
- If none of these conditions are met, the connector treats the event as a **pageView** event and converts to ***pageviewGA***;

## ***actions*** interface

The ***actions*** of the event must be described with an action in the past tense (e.g. **click**, **filled**, etc)

``` TS
this.taggingService.tag({
    page: '/gtm',
    title: 'tagging-gtm',
    event: TaggingEventEnum.INTERACTION,
    action: 'clicou'
});
```

> Events of type ***onClick*** have the value of the action as ***clicked***, while ***onBlur*** receive as the value ***filled***.

## Event data in lowercase

Another business rule in the GTM taxonomy is to send all information about the event in the format **lowercase** and with the words **separated by hyphen** instead of spaces.

``` TS
this.taggingService.tag({
    page: '/gtm',
    title: 'tagging-gtm',
    category: 'afe:tagging-gtm-connector',
    event: TaggingEventEnum.INTERACTION,
    action: 'clicou',
    isDirectInteraction: true,
    element: ***button:logar***,
});
```

## Collection Maps

The information that will be **filled in** is passed by the **Data Insights** team through the **collection maps**, a *functionality* map that describes the **flows** and **actions**.

So that the person responsible for developing it can carry out the implementation.

Some examples of implementation in the most diverse channels are available in the confluence of the GTM team itself.

> See examples in [collection maps](https://confluence.santanderbr.corp/display/TAGSBR/Mapas+de+Coleta)

## Validating data via ***window.dataLayer***

It is recommended to validate the information that is being added to the global data layer to be sure that the events will reach the platform correctly.

To perform the validation locally, simply open your browser's developer tool and in the **console** tab type ***window.dataLayer*** to access the array of objects that will be sent to GTM.
