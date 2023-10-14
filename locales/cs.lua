local Translations = {
    success = {
        this_vehicle_has_been_tuned = "Dieses Fahrzeug wurde getunt",
    },
    text = {
        this_is_not_the_idea_is_it = "Ist das nicht die Idee?",
        connecting_nos = "Verbindung zu NOS wird hergestellt...",
    },
    error = {
        tunerchip_vehicle_tuned = "TunerChip v1.05: Fahrzeug getunt!",
        this_vehicle_has_not_been_tuned = "Dieses Fahrzeug wurde nicht getunt",
        no_vehicle_nearby = "Kein Fahrzeug in der Nähe",
        tunerchip_vehicle_has_been_reset = "TunerChip v1.05: Fahrzeug wurde zurückgesetzt!",
        you_are_not_in_a_vehicle = "Du befindest dich nicht in einem Fahrzeug",
        you_cannot_do_that_from_this_seat = "Du kannst das nicht von diesem Sitz aus tun!",
        you_already_have_nos_active = "Du hast bereits aktives NOS",
        canceled = "Abgebrochen",
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