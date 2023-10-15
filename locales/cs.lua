local Translations = {
    success = {
        this_vehicle_has_been_tuned = "Toto vozidlo bylo vyladěno",
    },
    text = {
        this_is_not_the_idea_is_it = "Tohle není ten nápad, že ne?",
        connecting_nos = "Připojuji NOS...",
    },
    error = {
        tunerchip_vehicle_tuned = "TunerChip v1.05: Vozidlo bylo vyladěno!",
        this_vehicle_has_not_been_tuned = "Toto vozidlo nebylo vyladěno",
        no_vehicle_nearby = "Žádné vozidlo není v blízkosti",
        tunerchip_vehicle_has_been_reset = "TunerChip v1.05: Vozidlo bylo resetováno!",
        you_are_not_in_a_vehicle = "Nejste ve vozidle",
        you_cannot_do_that_from_this_seat = "Tohle nemůžete udělat z tohoto místa!",
        you_already_have_nos_active = "Máte již aktivní NOS",
        canceled = "Zrušeno",
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic