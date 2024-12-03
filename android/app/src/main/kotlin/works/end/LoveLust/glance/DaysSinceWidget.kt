package works.end.LoveLust.glance

import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

import kotlinx.serialization.json.Json

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.Color
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Button
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.padding
import androidx.glance.text.Text

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

import ActivityWidgetData

class DaysSinceWidget : GlanceAppWidget() {

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
    var days: Int = 0

    try {
      if (jsonString != null) {
        val json = Json { ignoreUnknownKeys = true }
        val widgetData = json.decodeFromString<ActivityWidgetData>(jsonString)
        if (widgetData.sexualActivity != null) {
            val formatter = DateTimeFormatter.ISO_DATE_TIME
            val sexualActivityDate = LocalDateTime.parse(widgetData.sexualActivity.date, formatter)
            val today = LocalDateTime.now(ZoneId.of("UTC"))
            days = ChronoUnit.DAYS.between(sexualActivityDate, today).toInt()
        }
      }
    } catch (e: Exception) {
      Box(modifier = GlanceModifier.background(Color.Red).padding(16.dp)) {
        Column {
          Text("${e.message}")
        }
      }
    }
    
    Box(modifier = GlanceModifier.background(Color.White).padding(16.dp)) {
      Column {
        Text("Days since activity")
        Text("$days days")
      }
    }
  }
}