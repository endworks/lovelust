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
    val type: String? = null,
    val practices: List<String>? = null,
    val mood: String? = null,
    val ejaculation: String? = null,
    val watched_porn: Boolean,
)

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

@Serializable
data class ActivityWidgetData(
    val soloActivity: Activity? = null,
    val sexualActivity: Activity? = null,
    val partner: Partner? = null,
    val safety: String? = null,
    val moodEmoji: String? = null
)