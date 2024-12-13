package works.end.LoveLust.glance

import kotlinx.serialization.Serializable

@Serializable
data class Activity(
    val id: String? = null,
    val partner: String? = null,
    val birth_control: String? = null,
    val partner_birth_control: String? = null,
    val date: String,
    val location: String? = null,
    val notes: String? = null,
    val duration: Int,
    val orgasms: Int,
    val partner_orgasms: Int,
    val place: String? = null,
    val initiator: String? = null,
    val rating: Int,
    val type: String = "SEXUAL_INTERCOURSE",
    val practices: List<String>? = null,
    val mood: String? = null,
    val ejaculation: String? = null,
    val watched_porn: Boolean,
)