package works.end.LoveLust.glance

import kotlinx.serialization.Serializable

@Serializable
data class Partner(
    val id: String? = null,
    val sex: String,
    val gender: String,
    val name: String,
    val meeting_date: String,
    val birth_day: String? = null,
    val notes: String? = null,
    val phone: String? = null,
    val instagram: String? = null,
    val x: String? = null,
    val snapchat: String? = null,
    val onlyfans: String? = null
)