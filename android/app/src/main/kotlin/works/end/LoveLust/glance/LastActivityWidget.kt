package works.end.LoveLust.glance

import java.util.Locale

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

import kotlinx.serialization.json.Json

import android.content.Context

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.Modifier

import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.padding
import androidx.glance.layout.Alignment
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

import androidx.compose.ui.unit.sp

import works.end.LoveLust.R


class LastActivityWidget : GlanceAppWidget() {

  override val stateDefinition: GlanceStateDefinition<*>?
    get() = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent {
      GlanceContent(context, currentState())
    }
  }

  @Composable
  private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
    val prefs = currentState.preferences
    val jsonString = prefs.getString("lastActivity", "{}")
    var partner = context.getString(R.string.unknown)
    var safety = ""
    var safetyColor = Color.Yellow
    var dayOfWeek = ""
    var dayOfMonth = ""
    var formattedDate = ""

    if (jsonString != null) {
      val json = Json { ignoreUnknownKeys = true }
      val widgetData = json.decodeFromString<ActivityWidgetData>(jsonString.toString())
      if (widgetData.sexualActivity != null) {
        val formatter = DateTimeFormatter.ISO_DATE_TIME
        val sexualActivityDate = LocalDateTime.parse(widgetData.sexualActivity.date, formatter)
        if(widgetData.partner != null) {
          partner = widgetData.partner.name
        }
        if (widgetData.safety == "SAFE") {
          safety = context.getString(R.string.safe)
          safetyColor = Color.Green
        } else if(widgetData.safety == "UNSAFE") {
          safety = context.getString(R.string.unsafe)
          safetyColor = Color.Red
        } else {
          safety = context.getString(R.string.partly_unsafe)
          safetyColor = Color.Yellow
        }
        dayOfWeek = sexualActivityDate.dayOfMonth.toString()
        dayOfMonth = sexualActivityDate.format(DateTimeFormatter.ofPattern("EEEE"))
        formattedDate = sexualActivityDate.format(DateTimeFormatter.ofPattern("d MMM yyyy"))
      }
    }
    Box(modifier = GlanceModifier.background(Color.White).padding(16.dp)) {
      Column(
        modifier = GlanceModifier
          .fillMaxSize()
          .padding(16.dp)
      ) {
        // Top row: Day of week and user name
        Row(
          modifier = GlanceModifier.fillMaxWidth()
        ) {
          Text(
            text = dayOfWeek.uppercase(),
            style = TextStyle(
              color = ColorProvider(Color.Red),
              fontSize = 14.sp
            )
          )
          Text(
            text = partner,
            style = TextStyle(
              color = ColorProvider(Color.Black),
              fontSize = 14.sp
            )
          )
        }

        Spacer(GlanceModifier.height(8.dp))

        // Big day of the month
        Text(
          text = dayOfMonth,
          style = TextStyle(
            color = ColorProvider(Color.Black),
            fontSize = 48.sp
          )
        )

        Spacer(GlanceModifier.height(16.dp))

        // Full date below
        Text(
          text = formattedDate.uppercase(),
          style = TextStyle(
            color = ColorProvider(Color.Gray),
            fontSize = 14.sp
          )
        )
        // Status in red
        Text(
          text = safety,
          style = TextStyle(
            color = ColorProvider(safetyColor),
            fontSize = 20.sp
          )
        )
      }
    }
  }
}